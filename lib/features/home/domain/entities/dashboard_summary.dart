import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.recommendedProducts,
    this.recentProducts = const [],
    this.riskyProducts = const [],
    required this.trendingKeywords,
  });

  final List<DashboardProduct> recommendedProducts;
  final List<DashboardProduct> recentProducts;
  final List<DashboardProduct> riskyProducts;
  final List<TrendingKeyword> trendingKeywords;

  bool get isEmpty =>
      recommendedProducts.isEmpty &&
      recentProducts.isEmpty &&
      riskyProducts.isEmpty &&
      trendingKeywords.isEmpty;
}
