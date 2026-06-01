import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductAnalysisResult {
  const ProductAnalysisResult({
    required this.averageRti,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.reviewDetails,
    this.trend = const [],
  });

  final double averageRti;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Map<int, ReviewRtiDetail> reviewDetails;
  final List<AnalysisTrendPoint> trend;
}

class AnalysisTrendPoint {
  const AnalysisTrendPoint({
    required this.date,
    required this.averageRti,
    required this.reviewCount,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final String date;
  final double averageRti;
  final int reviewCount;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
}
