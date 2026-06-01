import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductAnalysisResult {
  const ProductAnalysisResult({
    required this.averageRti,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.reviewDetails,
  });

  final double averageRti;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Map<int, ReviewRtiDetail> reviewDetails;
}
