import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class HandleOAuthCallbackUseCase {
  const HandleOAuthCallbackUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthUser>> call({
    required String accessToken,
    required String tokenType,
    required String email,
    required String nickname,
    required bool onboardingCompleted,
  }) {
    return _repository.handleOAuthCallback(
      accessToken: accessToken,
      tokenType: tokenType,
      email: email,
      nickname: nickname,
      onboardingCompleted: onboardingCompleted,
    );
  }
}
