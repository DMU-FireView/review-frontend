import 'package:re_view_front/features/landing/domain/entities/landing_stats.dart';

class LandingStatsDto {
  const LandingStatsDto({
    required this.totalReviewsAnalyzed,
    required this.totalProducts,
    required this.totalUsers,
    required this.detectionAccuracy,
    required this.serviceName,
    required this.tagline,
  });

  factory LandingStatsDto.fromJson(Map<String, dynamic> json) {
    return LandingStatsDto(
      totalReviewsAnalyzed: json['totalReviewsAnalyzed'] as int? ?? 0,
      totalProducts: json['totalProducts'] as int? ?? 0,
      totalUsers: json['totalUsers'] as int? ?? 0,
      detectionAccuracy: json['detectionAccuracy']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? 'Re:view',
      tagline: json['tagline']?.toString() ?? '',
    );
  }

  final int totalReviewsAnalyzed;
  final int totalProducts;
  final int totalUsers;
  final String detectionAccuracy;
  final String serviceName;
  final String tagline;

  LandingStats toEntity() => LandingStats(
    totalReviewsAnalyzed: totalReviewsAnalyzed,
    totalProducts: totalProducts,
    totalUsers: totalUsers,
    detectionAccuracy: detectionAccuracy,
    serviceName: serviceName,
    tagline: tagline,
  );
}
