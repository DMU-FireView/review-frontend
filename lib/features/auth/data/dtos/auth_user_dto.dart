import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.email,
    this.name,
    this.accessToken,
    this.tokenType,
    this.role,
    this.onboardingCompleted = false,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    return AuthUserDto(
      id: json['id']?.toString() ?? json['email']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? json['nickname']?.toString(),
      accessToken: json['accessToken']?.toString(),
      tokenType: json['tokenType']?.toString(),
      role: json['role']?.toString(),
      onboardingCompleted: json['onboardingCompleted'] == true,
    );
  }

  final String id;
  final String email;
  final String? name;
  final String? accessToken;
  final String? tokenType;
  final String? role;
  final bool onboardingCompleted;

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      accessToken: accessToken,
      tokenType: tokenType,
      role: role,
      onboardingCompleted: onboardingCompleted,
    );
  }
}
