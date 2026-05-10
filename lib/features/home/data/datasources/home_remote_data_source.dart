import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/home/data/dtos/dashboard_summary_dto.dart';

abstract interface class HomeRemoteDataSource {
  Future<DashboardSummaryDto> getHomeDashboard();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<DashboardSummaryDto> getHomeDashboard() async {
    final response = await _apiClient.get(_config.homeDashboardPath);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return DashboardSummaryDto.fromJson(data);
    }

    return const DashboardSummaryDto(
      recommendedProducts: [],
      trendingKeywords: [],
    );
  }
}
