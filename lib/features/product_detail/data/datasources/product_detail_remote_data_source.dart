import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/product_detail/data/dtos/product_detail_dto.dart';

abstract interface class ProductDetailRemoteDataSource {
  Future<ProductDetailDto> getProductDetail(int productId);

  Future<List<ProductReviewDto>> getProductReviews(
    int productId, {
    int page = 1,
    int pageSize = 20,
  });

  Future<ReviewInsightDto> getReviewInsight(int productId);

  Future<List<SimilarProductDto>> getSimilarProducts(int productId);
}

class ProductDetailRemoteDataSourceImpl
    implements ProductDetailRemoteDataSource {
  const ProductDetailRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<ProductDetailDto> getProductDetail(int productId) async {
    final response = await _apiClient.get('/api/products/$productId');
    final data = response.data as Map<String, dynamic>;
    return ProductDetailDto.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<ProductReviewDto>> getProductReviews(
    int productId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/products/$productId/reviews',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List;
    return list
        .map((e) => ProductReviewDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReviewInsightDto> getReviewInsight(int productId) async {
    final response = await _apiClient.get(
      '/api/products/$productId/insights',
    );
    final data = response.data as Map<String, dynamic>;
    return ReviewInsightDto.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<SimilarProductDto>> getSimilarProducts(int productId) async {
    final response = await _apiClient.get(
      '/api/products/$productId/similar',
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List;
    return list
        .map((e) => SimilarProductDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
