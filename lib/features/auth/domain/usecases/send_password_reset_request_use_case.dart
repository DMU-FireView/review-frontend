import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetRequestUseCase {
  const SendPasswordResetRequestUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call(String email) =>
      _repository.sendPasswordResetRequest(email);
}
