import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/auth/data/dtos/auth_user_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/signup_request_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUserDto> signup(SignupRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<AuthUserDto> signup(SignupRequestDto request) async {
    final path = _config.signupPath.trim();
    if (path.isEmpty) {
      throw const AuthEndpointNotConfiguredException();
    }

    final response = await _apiClient.post(path, data: request.toJson());
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return AuthUserDto.fromJson(data);
    }

    throw const FormatException('Invalid signup response');
  }
}

class AuthEndpointNotConfiguredException implements Exception {
  const AuthEndpointNotConfiguredException();
}
