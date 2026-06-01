import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/features/my_page/data/dtos/user_profile_dto.dart';

void main() {
  test('parses user profile response fields into domain entity', () {
    final dto = UserProfileDto.fromJson(const {
      'id': 7,
      'email': 'user@example.com',
      'nickname': '하정원',
      'role': 'USER',
      'createdAt': '2026-05-10T00:00:00',
      'onboardingCompleted': true,
    });

    final profile = dto.toEntity();

    expect(profile.id, 7);
    expect(profile.email, 'user@example.com');
    expect(profile.nickname, '하정원');
    expect(profile.role, 'USER');
    expect(profile.createdAt, DateTime.parse('2026-05-10T00:00:00'));
    expect(profile.onboardingCompleted, isTrue);
  });
}
