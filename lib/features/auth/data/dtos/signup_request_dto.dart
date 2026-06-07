class SignupRequestDto {
  const SignupRequestDto({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {'nickname': name, 'email': email, 'password': password};
  }
}
