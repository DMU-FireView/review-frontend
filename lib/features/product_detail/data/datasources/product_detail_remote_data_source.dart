import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/product_detail/data/dtos/product_analysis_dto.dart';
import 'package:re_view_front/features/product_detail/data/dtos/product_detail_dto.dart';

abstract interface class ProductDetailRemoteDataSource {
  Future<ProductDetailDto> getProductDetail(int productId);

  Future<List<ProductReviewDto>> getProductReviews(int productId);

  Future<void> submitReviewFeedback(int reviewId, String feedbackType);

  Future<bool> checkAnalysisHealth();

  Future<ProductAnalysisDto> triggerProductAnalysis(String productId);
}

class ProductDetailRemoteDataSourceImpl
    implements ProductDetailRemoteDataSource {
  const ProductDetailRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<ProductDetailDto> getProductDetail(int productId) async {
    final response = await _apiClient.get(
      '${_config.productPath}/$productId',
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();

      if (body is Map<String, dynamic>) {
        return ProductDetailDto.fromJson(body);
      }
    }

    throw ApiResponseException(message: '상품 정보를 불러오지 못했습니다.');
  }

  @override
  Future<List<ProductReviewDto>> getProductReviews(int productId) async {
    final response = await _apiClient.get(
      '${_config.productPath}/$productId/reviews',
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();

      if (body is List<dynamic>) {
        return ProductReviewDto.fromList(body);
      }
    }

    return const [];
  }

  @override
  Future<void> submitReviewFeedback(int reviewId, String feedbackType) async {
    final response = await _apiClient.post(
      '${_config.reviewFeedbackBasePath}/$reviewId/feedback',
      data: {'feedbackType': feedbackType},
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      payload.requireSuccess();
    }
  }

  @override
  Future<bool> checkAnalysisHealth() async {
    try {
      final response = await _apiClient.get(_config.analysisHealthPath);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = ApiResponse<Object?>.fromJson(data);
        final body = payload.requireSuccess();
        if (body is Map<String, dynamic>) {
          return body['status'] == 'ok';
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ProductAnalysisDto> triggerProductAnalysis(String productId) async {
    final response = await _apiClient.post(
      _config.analysisPath,
      data: {'productId': productId},
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();

      if (body is Map<String, dynamic>) {
        return ProductAnalysisDto.fromJson(body);
      }
    }

    throw ApiResponseException(message: 'AI 분석 결과를 불러오지 못했습니다.');
  }
}
