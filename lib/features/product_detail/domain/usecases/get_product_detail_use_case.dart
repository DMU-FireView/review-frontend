import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
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

  Future<Result<List<ProductReview>>> call(int productId) =>
      _repository.getProductReviews(productId);
}

class SubmitReviewFeedbackUseCase {
  const SubmitReviewFeedbackUseCase(this._repository);

  final ProductDetailRepository _repository;

  Future<Result<void>> call(int reviewId, String feedbackType) =>
      _repository.submitReviewFeedback(reviewId, feedbackType);
}
