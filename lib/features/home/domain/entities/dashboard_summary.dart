import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.recommendedProducts,
    required this.trendingKeywords,
  });

  final List<DashboardProduct> recommendedProducts;
  final List<TrendingKeyword> trendingKeywords;

  bool get isEmpty => recommendedProducts.isEmpty && trendingKeywords.isEmpty;
}
