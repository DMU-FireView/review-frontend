import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/home/data/dtos/dashboard_product_dto.dart';
import 'package:re_view_front/features/landing/data/dtos/landing_stats_dto.dart';

abstract interface class LandingRemoteDataSource {
  Future<LandingStatsDto> getLandingStats();
  Future<DashboardProductDto?> getFeaturedProduct();
}

class LandingRemoteDataSourceImpl implements LandingRemoteDataSource {
  const LandingRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<LandingStatsDto> getLandingStats() async {
    final response = await _apiClient.get(_config.landingStatsPath);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();
      if (body is Map<String, dynamic>) {
        return LandingStatsDto.fromJson(body);
      }
    }
    return const LandingStatsDto(
      totalReviewsAnalyzed: 0,
      totalProducts: 0,
      totalUsers: 0,
      detectionAccuracy: '',
      serviceName: 'Re:view',
      tagline: '',
    );
  }

  @override
  Future<DashboardProductDto?> getFeaturedProduct() async {
    final response = await _apiClient.get(_config.productPath);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();
      if (body is List && body.isNotEmpty) {
        final first = body.first;
        if (first is Map<String, dynamic>) {
          return DashboardProductDto.fromJson(first);
        }
      }
    }
    return null;
  }
}
