import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';

class ChatViewModel extends Notifier<ChatState> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  @override
  ChatState build() {
    // 로그아웃하거나 토큰이 만료되면 이전 계정의 대화를 지운다.
    ref.listen(isLoggedInProvider, (previous, next) {
      if (previous == true && !next) {
        state = ChatState(isOpen: state.isOpen);
      }
    });
    return const ChatState();
  }

  void open() => state = state.copyWith(isOpen: true);

  void close() => state = state.copyWith(isOpen: false);

  void toggle() => state = state.copyWith(isOpen: !state.isOpen);

  /// 대화를 비우고, 다음 질문부터 [productId] 기준의 새 세션을 시작한다.
  void startNew({int? productId}) {
    if (state.isSending) return;
    state = ChatState(isOpen: state.isOpen, sessionProductId: productId);
  }

  /// [productId]는 새 대화를 시작할 때만 서버에 반영된다.
  Future<void> send(String question, {int? productId}) async {
    final text = question.trim();
    if (text.isEmpty || state.isSending) return;

    final isNewSession = state.sessionId == null;
    state = state.copyWith(
      messages: [
        ...state.messages.where((m) => m.error == null),
        ChatMessage(role: ChatRole.user, content: text),
      ],
      isSending: true,
      sessionProductId: isNewSession ? productId : null,
      clearLastFailedQuestion: true,
    );

    final result = await _repository.ask(
      question: text,
      sessionId: state.sessionId,
      productId: isNewSession ? productId : null,
    );
    if (!ref.mounted) return;

    result.when(
      success: (reply) => state = state.copyWith(
        sessionId: reply.sessionId,
        isSending: false,
        messages: [
          ...state.messages,
          ChatMessage(
            role: ChatRole.assistant,
            content: reply.answer,
            blocked: reply.blocked,
            blockReason: reply.blockReason,
          ),
        ],
      ),
      failure: (failure) => state = state.copyWith(
        isSending: false,
        lastFailedQuestion: text,
        messages: [
          // 실패한 질문은 다시 시도할 때 새로 붙이므로 목록에서 뺀다.
          ...state.messages.sublist(0, state.messages.length - 1),
          ChatMessage(
            role: ChatRole.assistant,
            content: failure.message,
            error: _errorKindOf(failure),
          ),
        ],
      ),
    );
  }

  Future<void> retry({int? productId}) async {
    final question = state.lastFailedQuestion;
    if (question == null) return;
    await send(question, productId: productId);
  }

  ChatErrorKind _errorKindOf(Failure failure) {
    if (failure.statusCode == 503) return ChatErrorKind.unavailable;
    final cause = failure.cause;
    if (cause is DioException) {
      return switch (cause.type) {
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => ChatErrorKind.timeout,
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError => ChatErrorKind.network,
        _ => ChatErrorKind.unknown,
      };
    }
    return ChatErrorKind.unknown;
  }
}
