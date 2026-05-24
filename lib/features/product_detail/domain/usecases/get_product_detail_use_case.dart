import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/features/product_detail/domain/repositories/product_detail_repository.dart';

class GetProductDetailUseCase {
  const GetProductDetailUseCase(this._repository);

  final ProductDetailRepository _repository;

  Future<Result<ProductDetail>> call(int productId) =>
      _repository.getProductDetail(productId);
}

class GetProductReviewsUseCase {
  const GetProductReviewsUseCase(this._repository);

  final ProductDetailRepository _repository;

  Future<Result<List<ProductReview>>> call(
    int productId, {
    int page = 1,
    int pageSize = 20,
  }) => _repository.getProductReviews(productId, page: page, pageSize: pageSize);
}

class GetReviewInsightUseCase {
  const GetReviewInsightUseCase(this._repository);

  final ProductDetailRepository _repository;

  Future<Result<ReviewInsight>> call(int productId) =>
      _repository.getReviewInsight(productId);
}

class GetSimilarProductsUseCase {
  const GetSimilarProductsUseCase(this._repository);

  final ProductDetailRepository _repository;

  Future<Result<List<SimilarProduct>>> call(int productId) =>
      _repository.getSimilarProducts(productId);
}
