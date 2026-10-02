import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';

class ChatViewModel extends Notifier<ChatState> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  /// 대화를 초기화할 때마다 올린다. 응답이 늦게 와도 이미 지운 대화에 붙지 않게 한다.
  int _generation = 0;
  int _historyRequest = 0;

  @override
  ChatState build() {
    // 로그아웃하거나 토큰이 만료되면 이전 계정의 대화를 지운다.
    ref.listen(isLoggedInProvider, (previous, next) {
      if (previous == true && !next) {
        _generation++;
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
    _generation++;
    state = ChatState(isOpen: state.isOpen, sessionProductId: productId);
  }

  /// [productId]는 새 대화를 시작할 때만 서버에 반영된다.
  Future<void> send(String question, {int? productId}) async {
    final text = question.trim();
    if (text.isEmpty ||
        state.isSending ||
        state.isHistoryOpen ||
        state.isLoadingMessages ||
        !ref.read(isLoggedInProvider)) {
      return;
    }

    final isNewSession = state.sessionId == null;
    final generation = _generation;
    final questionMessage = ChatMessage(role: ChatRole.user, content: text);
    state = state.copyWith(
      messages: [
        ...state.messages.where((m) => m.error == null),
        questionMessage,
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
    // 로그아웃 알림이 응답보다 늦게 올 수 있어 로그인 상태를 직접 확인한다.
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider)) {
      return;
    }

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
          ...state.messages.where((m) => !identical(m, questionMessage)),
          ChatMessage(
            role: ChatRole.assistant,
            content: failure.message,
            error: _errorKindOf(failure),
          ),
        ],
      ),
    );
  }

  Future<void> showHistory() async {
    if (!ref.read(isLoggedInProvider) ||
        state.isSending ||
        state.isLoadingMessages ||
        state.isLoadingSessions) {
      return;
    }
    state = state.copyWith(
      isHistoryOpen: true,
      sessions: [],
      sessionsPage: 0,
      isLastSessionPage: true,
      clearHistoryError: true,
    );
    await _loadSessions(0);
  }

  Future<void> loadMoreSessions() async {
    if (!state.isHistoryOpen ||
        state.isLastSessionPage ||
        state.isLoadingSessions ||
        state.isLoadingMessages ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    await _loadSessions(state.sessionsPage + 1);
  }

  Future<void> _loadSessions(int page) async {
    final generation = _generation;
    final request = ++_historyRequest;
    state = state.copyWith(isLoadingSessions: true, clearHistoryError: true);
    final result = await _repository.getSessions(page: page, size: 20);
    if (!ref.mounted ||
        generation != _generation ||
        request != _historyRequest ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (loaded) {
        final items = page == 0
            ? loaded.items
            : [...state.sessions, ...loaded.items];
        final seen = <int>{};
        state = state.copyWith(
          sessions: [
            for (final session in items)
              if (seen.add(session.id)) session,
          ],
          sessionsPage: loaded.page,
          isLastSessionPage: loaded.isLast,
          isLoadingSessions: false,
        );
      },
      failure: (failure) => state = state.copyWith(
        isLoadingSessions: false,
        historyError: failure.message,
      ),
    );
  }

  void closeHistory() {
    ++_historyRequest;
    if (state.isLoadingMessages) ++_generation;
    state = state.copyWith(
      isHistoryOpen: false,
      isLoadingSessions: false,
      isLoadingMessages: false,
      clearHistoryError: true,
    );
  }

  Future<void> resumeSession(ChatSession session) async {
    if (!ref.read(isLoggedInProvider) || state.isSending) return;
    final generation = ++_generation;
    state = state.copyWith(
      isHistoryOpen: true,
      isLoadingMessages: true,
      isLoadingSessions: false,
      clearHistoryError: true,
    );
    final result = await _repository.getSessionMessages(session.id);
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (messages) => state = ChatState(
        isOpen: state.isOpen,
        sessionId: session.id,
        sessionProductId: int.tryParse(session.productId ?? ''),
        messages: messages,
      ),
      failure: (failure) => state = state.copyWith(
        isLoadingMessages: false,
        historyError: failure.message,
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
