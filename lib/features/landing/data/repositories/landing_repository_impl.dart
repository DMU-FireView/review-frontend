import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/data/datasources/landing_remote_data_source.dart';
import 'package:re_view_front/features/landing/domain/entities/landing_stats.dart';
import 'package:re_view_front/features/landing/domain/repositories/landing_repository.dart';

class LandingRepositoryImpl implements LandingRepository {
  const LandingRepositoryImpl(this._dataSource);

  final LandingRemoteDataSource _dataSource;

  @override
  Future<LandingStats> getLandingStats() async {
    final dto = await _dataSource.getLandingStats();
    return dto.toEntity();
  }

  @override
  Future<DashboardProduct?> getFeaturedProduct() async {
    final dto = await _dataSource.getFeaturedProduct();
    return dto?.toEntity();
  }
}
