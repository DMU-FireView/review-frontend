import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';

abstract interface class ChatRepository {
  /// [sessionId]가 null이면 새 대화를 시작한다. [productId]는 새 대화일 때만 반영된다.
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
  });
}
