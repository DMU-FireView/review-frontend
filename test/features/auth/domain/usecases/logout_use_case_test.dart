import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';
import 'package:re_view_front/features/auth/domain/usecases/logout_use_case.dart';

void main() {
  test('delegates logout to auth repository', () async {
    final repository = _FakeAuthRepository();
    final useCase = LogoutUseCase(repository);

    final result = await useCase();

    expect(result, isA<Success<void>>());
    expect(repository.logoutCalled, isTrue);
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool logoutCalled = false;

  @override
  Future<Result<void>> logout() async {
    logoutCalled = true;
    return const Success(null);
  }

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    return const Success(AuthUser(id: '1', email: 'user@example.com'));
  }

  @override
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return const Success(null);
  }

  @override
  Future<Result<Uri>> getOAuthLoginUri(OAuthProvider provider) async {
    return Success(Uri.parse('https://api.example.com/oauth'));
  }

  @override
  Future<Result<AuthUser>> handleOAuthCallback({
    required String accessToken,
    required String tokenType,
    required String email,
    required String nickname,
    required bool onboardingCompleted,
  }) async {
    return Success(
      AuthUser(
        id: email,
        email: email,
        name: nickname,
        accessToken: accessToken,
        tokenType: tokenType,
        onboardingCompleted: onboardingCompleted,
      ),
    );
  }

  @override
  Future<Result<String>> sendPasswordResetRequest(String email) async {
    return const Success('reset-token');
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return const Success(null);
  }
}
