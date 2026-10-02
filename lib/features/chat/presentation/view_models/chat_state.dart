import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

class ChatState {
  const ChatState({
    this.isOpen = false,
    this.messages = const [],
    this.sessionId,
    this.sessionProductId,
    this.isSending = false,
    this.lastFailedQuestion,
    this.isHistoryOpen = false,
    this.sessions = const [],
    this.sessionsPage = 0,
    this.isLastSessionPage = true,
    this.isLoadingSessions = false,
    this.isLoadingMessages = false,
    this.historyError,
  });

  final bool isOpen;
  final List<ChatMessage> messages;

  /// 서버 대화 세션. null이면 다음 질문이 새 대화를 시작한다.
  final int? sessionId;

  /// 현재 세션이 다루는 상품. 상품 없이 시작한 대화면 null.
  final int? sessionProductId;
  final bool isSending;

  /// 마지막으로 전송에 실패한 질문. 다시 시도할 때 쓴다.
  final String? lastFailedQuestion;

  final bool isHistoryOpen;
  final List<ChatSession> sessions;
  final int sessionsPage;
  final bool isLastSessionPage;
  final bool isLoadingSessions;
  final bool isLoadingMessages;
  final String? historyError;

  bool get hasConversation => messages.isNotEmpty;

  ChatState copyWith({
    bool? isOpen,
    List<ChatMessage>? messages,
    int? sessionId,
    bool clearSession = false,
    int? sessionProductId,
    bool? isSending,
    String? lastFailedQuestion,
    bool clearLastFailedQuestion = false,
    bool? isHistoryOpen,
    List<ChatSession>? sessions,
    int? sessionsPage,
    bool? isLastSessionPage,
    bool? isLoadingSessions,
    bool? isLoadingMessages,
    String? historyError,
    bool clearHistoryError = false,
  }) {
    return ChatState(
      isOpen: isOpen ?? this.isOpen,
      isHistoryOpen: isHistoryOpen ?? this.isHistoryOpen,
      sessions: sessions ?? this.sessions,
      sessionsPage: sessionsPage ?? this.sessionsPage,
      isLastSessionPage: isLastSessionPage ?? this.isLastSessionPage,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      historyError: clearHistoryError
          ? null
          : historyError ?? this.historyError,
      messages: messages ?? this.messages,
      sessionId: clearSession ? null : (sessionId ?? this.sessionId),
      sessionProductId: clearSession
          ? sessionProductId
          : (sessionProductId ?? this.sessionProductId),
      isSending: isSending ?? this.isSending,
      lastFailedQuestion: clearLastFailedQuestion
          ? null
          : (lastFailedQuestion ?? this.lastFailedQuestion),
    );
  }
}
