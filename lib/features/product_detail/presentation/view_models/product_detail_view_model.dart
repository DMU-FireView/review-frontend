import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/usecases/get_product_detail_use_case.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';

class ProductDetailViewModel extends Notifier<ProductDetailState> {
  ProductDetailViewModel(this._productId);

  final int _productId;

  late final GetProductDetailUseCase _getDetail;
  late final GetProductReviewsUseCase _getReviews;
  late final SubmitReviewFeedbackUseCase _submitFeedback;

  @override
  ProductDetailState build() {
    _getDetail = ref.watch(getProductDetailUseCaseProvider);
    _getReviews = ref.watch(getProductReviewsUseCaseProvider);
    _submitFeedback = ref.watch(submitReviewFeedbackUseCaseProvider);
    Future.microtask(() => _load(_productId));
    return const ProductDetailLoading();
  }

  Future<void> _load(int productId) async {
    if (!ref.mounted) return;
    state = const ProductDetailLoading();

    final detailResult = await _getDetail(productId);
    if (!ref.mounted) return;

    final detail = detailResult.when(success: (d) => d, failure: (_) => null);

    if (detail == null) {
      state = ProductDetailFailure(
        detailResult.when(
          success: (_) => const Failure(message: '알 수 없는 오류가 발생했습니다.'),
          failure: (f) => f,
        ),
      );
      return;
    }

    final reviewsResult = await _getReviews(productId);
    if (!ref.mounted) return;

    state = ProductDetailSuccess(
      detail: detail,
      reviews: reviewsResult.when(success: (r) => r, failure: (_) => const []),
      reviewInsight: const ReviewInsight(
        keywords: [],
        satisfactionPoints: [],
        dissatisfactionPoints: [],
      ),
      similarProducts: const [],
    );
  }

  Future<void> refresh() => _load(_productId);

  Future<bool> submitFeedback(int reviewId, String feedbackType) async {
    final result = await _submitFeedback(reviewId, feedbackType);
    return result.when(success: (_) => true, failure: (_) => false);
  }
}
