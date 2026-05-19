import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';

abstract interface class AuthRepository {
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<Uri>> getOAuthLoginUri(OAuthProvider provider);

  Future<Result<AuthUser>> handleOAuthCallback({
    required String accessToken,
    required String tokenType,
    required String email,
    required String nickname,
    required bool onboardingCompleted,
  });

  Future<Result<String>> sendPasswordResetRequest(String email);

  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });
}
