class LandingStats {
  const LandingStats({
    required this.totalReviewsAnalyzed,
    required this.totalProducts,
    required this.totalUsers,
    required this.detectionAccuracy,
    required this.serviceName,
    required this.tagline,
  });

  final int totalReviewsAnalyzed;
  final int totalProducts;
  final int totalUsers;
  final String detectionAccuracy;
  final String serviceName;
  final String tagline;
}
