import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthUser>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signup(name: name, email: email, password: password);
  }

  Future<Result<Uri>> startOAuth(OAuthProvider provider) {
    return _repository.getOAuthLoginUri(provider);
  }
}
