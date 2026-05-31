import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/domain/entities/landing_stats.dart';

abstract interface class LandingRepository {
  Future<LandingStats> getLandingStats();
  Future<DashboardProduct?> getFeaturedProduct();
}
