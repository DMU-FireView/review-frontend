class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.nickname,
    required this.role,
    required this.createdAt,
    required this.onboardingCompleted,
  });

  final int id;
  final String email;
  final String nickname;
  final String role;
  final DateTime? createdAt;
  final bool onboardingCompleted;

  String get initials {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) return 'MY';
    final end = trimmed.length < 2 ? trimmed.length : 2;
    return trimmed.substring(0, end).toUpperCase();
  }
}
