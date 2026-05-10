class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: json['data'] as T?,
      errorCode: json['errorCode']?.toString(),
    );
  }

  final bool success;
  final String? message;
  final T? data;
  final String? errorCode;

  T? requireSuccess() {
    if (!success) {
      throw ApiResponseException(
        message: message ?? '요청을 처리하지 못했습니다.',
        code: errorCode,
      );
    }

    return data;
  }
}

class ApiResponseException implements Exception {
  const ApiResponseException({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'ApiResponseException(message: $message, code: $code)';
}
