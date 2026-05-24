import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';

abstract interface class ProductDetailRepository {
  Future<Result<ProductDetail>> getProductDetail(int productId);

  Future<Result<List<ProductReview>>> getProductReviews(
    int productId, {
    int page = 1,
    int pageSize = 20,
  });

  Future<Result<ReviewInsight>> getReviewInsight(int productId);

  Future<Result<List<SimilarProduct>>> getSimilarProducts(int productId);
}
