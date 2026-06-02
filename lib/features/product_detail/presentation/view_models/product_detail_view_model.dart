import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
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
  late final CheckAnalysisHealthUseCase _checkHealth;
  late final TriggerProductAnalysisUseCase _triggerAnalysis;

  @override
  ProductDetailState build() {
    _getDetail = ref.watch(getProductDetailUseCaseProvider);
    _getReviews = ref.watch(getProductReviewsUseCaseProvider);
    _submitFeedback = ref.watch(submitReviewFeedbackUseCaseProvider);
    _checkHealth = ref.watch(checkAnalysisHealthUseCaseProvider);
    _triggerAnalysis = ref.watch(triggerProductAnalysisUseCaseProvider);
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

    final reviews = reviewsResult.when(
      success: (r) => r,
      failure: (_) => const <ProductReview>[],
    );

    state = ProductDetailSuccess(
      detail: detail,
      reviews: reviews,
      reviewInsight: const ReviewInsight(
        keywords: [],
        satisfactionPoints: [],
        dissatisfactionPoints: [],
      ),
      similarProducts: const [],
      isAnalyzing: true,
    );

    _triggerAnalysisInBackground(productId.toString());
  }

  Future<void> _triggerAnalysisInBackground(String productId) async {
    final isHealthy = await _checkHealth();
    if (!ref.mounted) return;

    if (!isHealthy) {
      final current = state;
      if (current is ProductDetailSuccess) {
        state = current.copyWith(isAnalyzing: false);
      }
      return;
    }

    final analysisResult = await _triggerAnalysis(productId);
    if (!ref.mounted) return;

    final current = state;
    if (current is! ProductDetailSuccess) return;

    analysisResult.when(
      success: (analysis) {
        final enrichedReviews = current.reviews.map((review) {
          final detail = analysis.reviewDetails[review.id];
          if (detail == null) return review;
          return ProductReview(
            id: review.id,
            authorName: review.authorName,
            authorAvatarUrl: review.authorAvatarUrl,
            rating: review.rating,
            content: review.content,
            createdAt: review.createdAt,
            platform: review.platform,
            isVerifiedPurchase: review.isVerifiedPurchase,
            rtiScore: review.rtiScore,
            rtiColor: review.rtiColor,
            rtiLabel: review.rtiLabel,
            imageUrls: review.imageUrls,
            hashtags: review.hashtags,
            reasons: review.reasons,
            rtiDetail: detail,
          );
        }).toList();

        if (ref.mounted) {
          state = current.copyWith(
            reviews: enrichedReviews,
            isAnalyzing: false,
            safeCount: analysis.safeCount,
            warnCount: analysis.warnCount,
            dangerCount: analysis.dangerCount,
            trend: analysis.trend,
            rtiSummary: current.detail.rtiSummary.copyWith(
              realReviewRatio: analysis.realReviewRatio / 100,
              realReviewLabel: '${analysis.realReviewRatio.toStringAsFixed(1)}%',
              adSuspicionRatio: analysis.adSuspicionRatio / 100,
              adSuspicionLabel: '${analysis.adSuspicionRatio.toStringAsFixed(1)}%',
              repetitionRatio: analysis.repetitiveRatio / 100,
              repetitionLabel: '${analysis.repetitiveRatio.toStringAsFixed(1)}%',
            ),
            trustSignals: analysis.trustSignals,
          );
        }
      },
      failure: (_) {
        if (ref.mounted) {
          state = current.copyWith(isAnalyzing: false);
        }
      },
    );
  }

  Future<void> refresh() => _load(_productId);

  Future<bool> submitFeedback(int reviewId, String feedbackType) async {
    final result = await _submitFeedback(reviewId, feedbackType);
    return result.when(success: (_) => true, failure: (_) => false);
  }
}
