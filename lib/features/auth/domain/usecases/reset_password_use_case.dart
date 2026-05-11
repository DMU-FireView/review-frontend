import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({
    required String token,
    required String newPassword,
  }) =>
      _repository.resetPassword(token: token, newPassword: newPassword);
}
