class AppException implements Exception {
  const AppException(this.message, {this.code, this.statusCode, this.cause});

  final String message;
  final String? code;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}
