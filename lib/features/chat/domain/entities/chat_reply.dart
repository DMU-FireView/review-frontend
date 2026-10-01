/// 질문 전송 결과.
class ChatReply {
  const ChatReply({
    required this.sessionId,
    required this.answer,
    required this.blocked,
    this.blockReason,
  });

  /// 다음 질문에 그대로 넣으면 대화가 이어진다.
  final int sessionId;
  final String answer;
  final bool blocked;
  final String? blockReason;
}
