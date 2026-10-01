import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_reply_dto.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatReply> ask({
    required String question,
    int? sessionId,
    int? productId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<ChatReply> ask({
    required String question,
    int? sessionId,
    int? productId,
  }) async {
    final response = await _apiClient.post(
      '${_config.chatBasePath}/messages',
      data: <String, dynamic>{
        'question': question,
        'sessionId': ?sessionId,
        'productId': ?productId?.toString(),
      },
      options: Options(receiveTimeout: _config.chatReceiveTimeout),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return ChatReplyDto(body).toEntity();
      }
    }
    throw Exception('Invalid response format');
  }
}
