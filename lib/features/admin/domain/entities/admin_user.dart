/// 관리자 사용자 목록 항목.
class AdminUser {
  const AdminUser({
    required this.userId,
    required this.email,
    required this.nickname,
    required this.role,
    required this.provider,
    required this.atiScore,
    required this.createdAt,
  });

  final int userId;
  final String email;
  final String nickname;

  /// USER / ADMIN
  final String role;

  /// LOCAL / GOOGLE / NAVER 등. 일반 가입이면 null일 수 있다.
  final String? provider;

  /// 사용자 신뢰 지수. 산정 전이면 null.
  final double? atiScore;
  final DateTime? createdAt;

  bool get isAdmin => role.toUpperCase() == 'ADMIN';
}
