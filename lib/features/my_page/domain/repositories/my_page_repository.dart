import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';

abstract interface class MyPageRepository {
  Future<Result<UserProfile>> getMyProfile();
}
