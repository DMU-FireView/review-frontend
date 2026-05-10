import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({required this.id, required this.email, this.name});

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    return AuthUserDto(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? json['nickname']?.toString(),
    );
  }

  final String id;
  final String email;
  final String? name;

  AuthUser toEntity() {
    return AuthUser(id: id, email: email, name: name);
  }
}
