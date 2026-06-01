import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';

class UserProfileDto {
  const UserProfileDto({
    required this.id,
    required this.email,
    required this.nickname,
    required this.role,
    required this.createdAt,
    required this.onboardingCompleted,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: _readInt(json, ['id', 'userId']),
      email: _readString(json, ['email']),
      nickname: _readString(json, ['nickname', 'name']),
      role: _readString(json, ['role']),
      createdAt: _readDateTime(json, ['createdAt', 'created_at']),
      onboardingCompleted:
          json['onboardingCompleted'] == true ||
          json['onboarding_completed'] == true,
    );
  }

  final int id;
  final String email;
  final String nickname;
  final String role;
  final DateTime? createdAt;
  final bool onboardingCompleted;

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      nickname: nickname,
      role: role,
      createdAt: createdAt,
      onboardingCompleted: onboardingCompleted,
    );
  }
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return '';
}

int _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
  }
  return 0;
}

DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
  }
  return null;
}
