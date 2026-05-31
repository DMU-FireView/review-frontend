import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/domain/entities/landing_stats.dart';
import 'package:re_view_front/features/landing/domain/repositories/landing_repository.dart';

class GetLandingDataUseCase {
  const GetLandingDataUseCase(this._repository);

  final LandingRepository _repository;

  Future<({LandingStats stats, DashboardProduct? featuredProduct})> call() async {
    final statsFuture = _repository.getLandingStats();
    final productFuture = _repository.getFeaturedProduct();
    final stats = await statsFuture;
    final product = await productFuture;
    return (stats: stats, featuredProduct: product);
  }
}
