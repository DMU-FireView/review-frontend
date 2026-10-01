import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';

class ChatState {
  const ChatState({
    this.isOpen = false,
    this.messages = const [],
    this.sessionId,
    this.sessionProductId,
    this.isSending = false,
    this.lastFailedQuestion,
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
  }) {
    return ChatState(
      isOpen: isOpen ?? this.isOpen,
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
