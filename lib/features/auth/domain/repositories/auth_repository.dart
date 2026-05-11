import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  });
}
