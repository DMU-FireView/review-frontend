import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/usecases/get_product_detail_use_case.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';

class ProductDetailViewModel
    extends FamilyNotifier<ProductDetailState, int> {
  late final GetProductDetailUseCase _getDetail;
  late final GetProductReviewsUseCase _getReviews;
  late final GetReviewInsightUseCase _getInsight;
  late final GetSimilarProductsUseCase _getSimilar;

  @override
  ProductDetailState build(int productId) {
    _getDetail = ref.watch(getProductDetailUseCaseProvider);
    _getReviews = ref.watch(getProductReviewsUseCaseProvider);
    _getInsight = ref.watch(getReviewInsightUseCaseProvider);
    _getSimilar = ref.watch(getSimilarProductsUseCaseProvider);
    Future.microtask(() => _load(productId));
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
    final insightResult = await _getInsight(productId);
    final similarResult = await _getSimilar(productId);
    if (!ref.mounted) return;

    state = ProductDetailSuccess(
      detail: detail,
      reviews: reviewsResult.when(success: (r) => r, failure: (_) => const []),
      reviewInsight: insightResult.when(
        success: (i) => i,
        failure: (_) => const ReviewInsight(
          keywords: [],
          satisfactionPoints: [],
          dissatisfactionPoints: [],
        ),
      ),
      similarProducts: similarResult.when(
        success: (s) => s,
        failure: (_) => const [],
      ),
    );
  }

  Future<void> refresh(int productId) => _load(productId);
}
