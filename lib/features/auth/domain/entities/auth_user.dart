class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.accessToken,
    this.tokenType,
    this.role,
    this.onboardingCompleted = false,
  });

  final String id;
  final String email;
  final String? name;
  final String? accessToken;
  final String? tokenType;
  final String? role;
  final bool onboardingCompleted;
}
