import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';

class ApiClient {
  ApiClient(AppConfig config, {AuthTokenStore? tokenStore})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          contentType: 'application/json',
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
    // 요청 헤더(Authorization)와 응답 본문을 출력하므로 릴리스 빌드에서는 등록하지 않는다.
    if (kDebugMode) {
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
  }

  final Dio dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete(path, queryParameters: queryParameters);
  }

}
