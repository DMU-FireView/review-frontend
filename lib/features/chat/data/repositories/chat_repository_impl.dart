import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
  }) async {
    try {
      final reply = await _dataSource.ask(
        question: question,
        sessionId: sessionId,
        productId: productId,
      );
      return Success(reply);
    } on DioException catch (e) {
      final data = e.response?.data;
      return FailureResult(
        Failure(
          message: data is Map<String, dynamic>
              ? data['message']?.toString() ?? e.message ?? ''
              : e.message ?? '',
          code: data is Map<String, dynamic>
              ? data['errorCode']?.toString()
              : null,
          statusCode: e.response?.statusCode,
          cause: e,
        ),
      );
    } on ApiResponseException catch (e) {
      return FailureResult(Failure(message: e.message, code: e.code, cause: e));
    } catch (e) {
      return FailureResult(Failure(message: e.toString(), cause: e));
    }
  }
}
