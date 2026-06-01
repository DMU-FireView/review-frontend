import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/my_page/domain/repositories/my_page_repository.dart';

class GetMyProfileUseCase {
  const GetMyProfileUseCase(this._repository);

  final MyPageRepository _repository;

  Future<Result<UserProfile>> call() {
    return _repository.getMyProfile();
  }
}
