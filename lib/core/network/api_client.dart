import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';

class ApiClient {
  ApiClient(AppConfig config)
    : dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          headers: const {'Accept': 'application/json'},
        ),
      );

  final Dio dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }
}
