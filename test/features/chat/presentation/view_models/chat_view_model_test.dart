import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_view_model.dart';

void main() {
  late _FakeChatRepository repository;
  late _TestAuthTokenStore tokenStore;
  late ProviderContainer container;
  late ChatViewModel viewModel;

  setUp(() {
    repository = _FakeChatRepository();
    tokenStore = _TestAuthTokenStore();
    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(repository),
        authTokenStoreProvider.overrideWith(() => tokenStore),
        apiClientProvider.overrideWith((ref) {
          throw StateError('Unexpected API access in chat test');
        }),
      ],
    );
    viewModel = container.read(chatViewModelProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('stores user and assistant messages and session on success', () async {
    await viewModel.send('  리뷰를 설명해 주세요  ', productId: 1);

    final state = container.read(chatViewModelProvider);
    expect(state.sessionId, 7);
    expect(state.sessionProductId, 1);
    expect(state.isSending, isFalse);
    expect(state.lastFailedQuestion, isNull);
    expect(state.messages.map((message) => message.role), [
      ChatRole.user,
      ChatRole.assistant,
    ]);
    expect(state.messages.map((message) => message.content), [
      '리뷰를 설명해 주세요',
      '리뷰 분석 답변',
    ]);
    expect(repository.requests.single, (
      question: '리뷰를 설명해 주세요',
      sessionId: null,
      productId: 1,
    ));
  });

  test('passes product only for a new session and keeps its context', () async {
    await viewModel.send('첫 질문', productId: 1);
    await viewModel.send('두 번째 질문', productId: 2);

    expect(repository.requests.last, (
      question: '두 번째 질문',
      sessionId: 7,
      productId: null,
    ));
    final state = container.read(chatViewModelProvider);
    expect(state.sessionProductId, 1);
    expect(state.messages, hasLength(4));
  });

  test(
    'removes only the failed question and stores an error and retry text',
    () async {
      await viewModel.send('첫 질문', productId: 1);
      repository.result = const FailureResult(Failure(message: '전송 실패'));

      await viewModel.send('실패 질문', productId: 2);

      final state = container.read(chatViewModelProvider);
      expect(state.messages.map((message) => message.content), [
        '첫 질문',
        '리뷰 분석 답변',
        '전송 실패',
      ]);
      expect(state.messages.last.role, ChatRole.assistant);
      expect(state.messages.last.error, ChatErrorKind.unknown);
      expect(state.lastFailedQuestion, '실패 질문');
      expect(state.isSending, isFalse);
      expect(state.sessionId, 7);
      expect(state.sessionProductId, 1);
    },
  );

  test(
    'retries a failed new-session question without keeping the error',
    () async {
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('다시 질문', productId: 1);
      repository.result = _reply;

      await viewModel.retry(productId: 1);

      expect(repository.requests, hasLength(2));
      expect(repository.requests.last, repository.requests.first);
      final state = container.read(chatViewModelProvider);
      expect(state.messages.map((message) => message.content), [
        '다시 질문',
        '리뷰 분석 답변',
      ]);
      expect(state.messages.every((message) => message.error == null), isTrue);
      expect(state.lastFailedQuestion, isNull);
      expect(state.sessionId, 7);
      expect(state.sessionProductId, 1);
    },
  );

  test(
    'retries within an existing session without passing another product',
    () async {
      await viewModel.send('첫 질문', productId: 1);
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('추가 질문', productId: 2);
      repository.result = _reply;

      await viewModel.retry(productId: 2);

      expect(repository.requests.last, (
        question: '추가 질문',
        sessionId: 7,
        productId: null,
      ));
      expect(container.read(chatViewModelProvider).messages, hasLength(4));
      expect(container.read(chatViewModelProvider).sessionProductId, 1);
      expect(container.read(chatViewModelProvider).lastFailedQuestion, isNull);
    },
  );

  test('does not retry without a failed question', () async {
    await viewModel.retry(productId: 1);
    expect(repository.requests, isEmpty);
  });

  final errorCases = <({String name, Failure failure, ChatErrorKind kind})>[
    (
      name: '503',
      failure: const Failure(message: 'unavailable', statusCode: 503),
      kind: ChatErrorKind.unavailable,
    ),
    (
      name: 'receiveTimeout',
      failure: Failure(
        message: 'timeout',
        cause: DioException(
          requestOptions: RequestOptions(path: '/api/chat/messages'),
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      kind: ChatErrorKind.timeout,
    ),
    (
      name: 'connectionError',
      failure: Failure(
        message: 'network',
        cause: DioException(
          requestOptions: RequestOptions(path: '/api/chat/messages'),
          type: DioExceptionType.connectionError,
        ),
      ),
      kind: ChatErrorKind.network,
    ),
  ];

  for (final errorCase in errorCases) {
    test('maps ${errorCase.name} to its error kind', () async {
      repository.result = FailureResult(errorCase.failure);
      await viewModel.send('질문');

      final state = container.read(chatViewModelProvider);
      expect(state.messages, hasLength(1));
      expect(state.messages.single.role, ChatRole.assistant);
      expect(state.messages.single.error, errorCase.kind);
      expect(state.messages.single.content, errorCase.failure.message);
      expect(state.lastFailedQuestion, '질문');
      expect(state.isSending, isFalse);
    });
  }

  test(
    'stores a blocked reply and its reason without a transport error',
    () async {
      repository.result = const Success(
        ChatReply(
          sessionId: 9,
          answer: '리뷰에 관한 질문을 해 주세요',
          blocked: true,
          blockReason: 'OFF_TOPIC',
        ),
      );
      await viewModel.send('차단 질문');

      final state = container.read(chatViewModelProvider);
      expect(state.sessionId, 9);
      expect(state.messages.last.content, '리뷰에 관한 질문을 해 주세요');
      expect(state.messages.last.blocked, isTrue);
      expect(state.messages.last.blockReason, 'OFF_TOPIC');
      expect(state.messages.last.error, isNull);
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);
    },
  );

  test(
    'starts a new conversation and clears session, messages and failure',
    () async {
      viewModel.open();
      await viewModel.send('첫 질문', productId: 1);
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('실패 질문');

      viewModel.startNew(productId: 2);

      final state = container.read(chatViewModelProvider);
      expect(state.isOpen, isTrue);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, 2);
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);

      repository.result = _reply;
      await viewModel.send('새 질문', productId: 2);
      expect(repository.requests.last.sessionId, isNull);
      expect(repository.requests.last.productId, 2);
      viewModel.startNew();
      expect(container.read(chatViewModelProvider).sessionProductId, isNull);
    },
  );

  test(
    'ignores a duplicate send and a new conversation while sending',
    () async {
      final pending = Completer<Result<ChatReply>>();
      repository.pending = pending;
      final sending = viewModel.send('첫 질문', productId: 1);

      expect(container.read(chatViewModelProvider).isSending, isTrue);
      await viewModel.send('중복 질문', productId: 2);
      viewModel.startNew(productId: 2);
      expect(repository.requests, hasLength(1));
      expect(
        container.read(chatViewModelProvider).messages.single.content,
        '첫 질문',
      );
      expect(container.read(chatViewModelProvider).sessionProductId, 1);

      pending.complete(_reply);
      await sending;
      expect(container.read(chatViewModelProvider).messages, hasLength(2));
      expect(container.read(chatViewModelProvider).isSending, isFalse);
    },
  );

  test('ignores an empty question', () async {
    await viewModel.send('  \n  ', productId: 1);
    expect(repository.requests, isEmpty);
    expect(container.read(chatViewModelProvider).messages, isEmpty);
  });

  test(
    'clears the conversation on logout and preserves the open panel',
    () async {
      viewModel.open();
      await viewModel.send('첫 질문', productId: 1);
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('실패 질문');

      tokenStore.setLoggedIn(false);
      await container.pump();

      final state = container.read(chatViewModelProvider);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, isNull);
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);
      expect(state.isOpen, isTrue);
    },
  );

  test(
    'does not restore a previous conversation when a reply arrives after logout',
    () async {
      final pending = Completer<Result<ChatReply>>();
      repository.pending = pending;
      final sending = viewModel.send('로그아웃 전 질문', productId: 1);
      tokenStore.setLoggedIn(false);
      await container.pump();
      expect(container.read(chatViewModelProvider).messages, isEmpty);

      pending.complete(_reply);
      await sending;

      final state = container.read(chatViewModelProvider);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, isNull);
    },
  );

  test('ignores a failed request that completes after logout', () async {
    final pending = Completer<Result<ChatReply>>();
    repository.pending = pending;
    final sending = viewModel.send('로그아웃 전 질문', productId: 1);
    tokenStore.setLoggedIn(false);
    await container.pump();

    pending.complete(const FailureResult(Failure(message: '전송 실패')));
    await sending;

    final state = container.read(chatViewModelProvider);
    expect(state.messages, isEmpty);
    expect(state.lastFailedQuestion, isNull);
    expect(state.isSending, isFalse);
  });
}

const _reply = Success(
  ChatReply(sessionId: 7, answer: '리뷰 분석 답변', blocked: false),
);

typedef _Request = ({String question, int? sessionId, int? productId});

class _FakeChatRepository implements ChatRepository {
  Result<ChatReply> result = _reply;
  Completer<Result<ChatReply>>? pending;
  final List<_Request> requests = [];

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
  }) async {
    requests.add((
      question: question,
      sessionId: sessionId,
      productId: productId,
    ));
    return pending == null ? result : await pending!.future;
  }
}

class _TestAuthTokenStore extends AuthTokenStore {
  @override
  bool build() => true;

  void setLoggedIn(bool value) => state = value;
}
