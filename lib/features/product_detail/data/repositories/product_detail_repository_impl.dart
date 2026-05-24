import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/data/datasources/product_detail_remote_data_source.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/features/product_detail/domain/repositories/product_detail_repository.dart';
import 'package:re_view_front/features/product_detail/presentation/data/mock_product_detail.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  const ProductDetailRepositoryImpl(this._remoteDataSource);

  final ProductDetailRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ProductDetail>> getProductDetail(int productId) async {
    try {
      final dto = await _remoteDataSource.getProductDetail(productId);
      return Success(dto.toEntity());
    } catch (_) {
      return Success(mockProductDetailFor(productId));
    }
  }

  @override
  Future<Result<List<ProductReview>>> getProductReviews(
    int productId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final dtos = await _remoteDataSource.getProductReviews(
        productId,
        page: page,
        pageSize: pageSize,
      );
      return Success(dtos.map((d) => d.toEntity()).toList());
    } catch (_) {
      return Success(mockReviewsFor(productId));
    }
  }

  @override
  Future<Result<ReviewInsight>> getReviewInsight(int productId) async {
    try {
      final dto = await _remoteDataSource.getReviewInsight(productId);
      return Success(dto.toEntity());
    } catch (_) {
      return Success(mockInsightFor(productId));
    }
  }

  @override
  Future<Result<List<SimilarProduct>>> getSimilarProducts(
    int productId,
  ) async {
    try {
      final dtos = await _remoteDataSource.getSimilarProducts(productId);
      return Success(dtos.map((d) => d.toEntity()).toList());
    } catch (_) {
      return Success(mockSimilarProductsFor(productId));
    }
  }
}
