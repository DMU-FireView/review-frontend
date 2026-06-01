import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/product_detail/data/datasources/product_detail_remote_data_source.dart';
import 'package:re_view_front/features/product_detail/data/repositories/product_detail_repository_impl.dart';
import 'package:re_view_front/features/product_detail/domain/repositories/product_detail_repository.dart';
import 'package:re_view_front/features/product_detail/domain/usecases/get_product_detail_use_case.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_view_model.dart';

final productDetailRemoteDataSourceProvider =
    Provider<ProductDetailRemoteDataSource>((ref) {
      return ProductDetailRemoteDataSourceImpl(
        apiClient: ref.watch(apiClientProvider),
        config: ref.watch(appConfigProvider),
      );
    });

final productDetailRepositoryProvider =
    Provider<ProductDetailRepository>((ref) {
      return ProductDetailRepositoryImpl(
        ref.watch(productDetailRemoteDataSourceProvider),
      );
    });

final getProductDetailUseCaseProvider =
    Provider<GetProductDetailUseCase>((ref) {
      return GetProductDetailUseCase(
        ref.watch(productDetailRepositoryProvider),
      );
    });

final getProductReviewsUseCaseProvider =
    Provider<GetProductReviewsUseCase>((ref) {
      return GetProductReviewsUseCase(
        ref.watch(productDetailRepositoryProvider),
      );
    });

final submitReviewFeedbackUseCaseProvider =
    Provider<SubmitReviewFeedbackUseCase>((ref) {
      return SubmitReviewFeedbackUseCase(
        ref.watch(productDetailRepositoryProvider),
      );
    });

final checkAnalysisHealthUseCaseProvider =
    Provider<CheckAnalysisHealthUseCase>((ref) {
      return CheckAnalysisHealthUseCase(
        ref.watch(productDetailRepositoryProvider),
      );
    });

final triggerProductAnalysisUseCaseProvider =
    Provider<TriggerProductAnalysisUseCase>((ref) {
      return TriggerProductAnalysisUseCase(
        ref.watch(productDetailRepositoryProvider),
      );
    });

final productDetailViewModelProvider = NotifierProvider.family<
  ProductDetailViewModel,
  ProductDetailState,
  int
>(ProductDetailViewModel.new);
