import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';

abstract interface class ProductDetailRepository {
  Future<Result<ProductDetail>> getProductDetail(int productId);

  Future<Result<List<ProductReview>>> getProductReviews(int productId);

  Future<Result<void>> submitReviewFeedback(
    int reviewId,
    String feedbackType,
  );

  Future<Result<ProductAnalysisResult>> triggerProductAnalysis(String productId);
}
