import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl();

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    return const FailureResult(Failure(message: '로그인 API가 아직 연결되지 않았습니다.'));
  }
}
