import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';

Failure failureFromDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final data = error.response?.data;
  final serverMessage = data is Map<String, dynamic>
      ? data['message']?.toString()
      : null;

  return Failure(
    message: serverMessage ?? _messageForType(error.type),
    code: error.type.name,
    statusCode: statusCode,
    cause: error,
  );
}

String _messageForType(DioExceptionType type) {
  return switch (type) {
    DioExceptionType.connectionTimeout => '서버 연결 시간이 초과되었습니다.',
    DioExceptionType.sendTimeout => '요청 전송 시간이 초과되었습니다.',
    DioExceptionType.receiveTimeout => '응답 대기 시간이 초과되었습니다.',
    DioExceptionType.badCertificate => '서버 인증서를 확인할 수 없습니다.',
    DioExceptionType.badResponse => '서버 응답을 처리하지 못했습니다.',
    DioExceptionType.cancel => '요청이 취소되었습니다.',
    DioExceptionType.connectionError => '서버에 연결할 수 없습니다.',
    DioExceptionType.unknown => '알 수 없는 네트워크 오류가 발생했습니다.',
  };
}
