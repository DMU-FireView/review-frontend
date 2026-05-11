class PasswordResetRequestDto {
  const PasswordResetRequestDto({required this.token, required this.newPassword});

  final String token;
  final String newPassword;

  Map<String, dynamic> toJson() => {
        'token': token,
        'newPassword': newPassword,
      };
}
