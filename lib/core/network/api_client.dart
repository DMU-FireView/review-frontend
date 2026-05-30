import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';

class ApiClient {
  ApiClient(AppConfig config, {AuthTokenStore? tokenStore})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          headers: const {'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStore?.accessToken;
          final tokenType = tokenStore?.tokenType ?? 'Bearer';
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = '$tokenType $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401 &&
              tokenStore?.accessToken != null) {
            tokenStore?.clear();
          }
          handler.next(error);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  final Dio dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(String path, {Object? data}) {
    return dio.post(path, data: data);
  }

  Future<Response<dynamic>> put(String path, {Object? data}) {
    return dio.put(path, data: data);
  }

  Future<Response<dynamic>> delete(String path) {
    return dio.delete(path);
  }
}
