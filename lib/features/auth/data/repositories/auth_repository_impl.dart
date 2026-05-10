import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._config);

  final AppConfig _config;

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    return const FailureResult(Failure(message: '로그인 API가 아직 연결되지 않았습니다.'));
  }

  @override
  Future<Result<Uri>> getOAuthLoginUri(OAuthProvider provider) async {
    final path = switch (provider) {
      OAuthProvider.naver => _config.naverOAuthPath,
      OAuthProvider.google => _config.googleOAuthPath,
    };

    if (path.trim().isEmpty) {
      return FailureResult(
        Failure(message: '${provider.label} 로그인 경로가 설정되지 않았습니다.'),
      );
    }

    final baseUrl = _config.apiBaseUrl.trim();
    final uri = baseUrl.isEmpty
        ? Uri.parse(path)
        : Uri.parse(baseUrl).resolve(path);

    return Success(uri);
  }
}
