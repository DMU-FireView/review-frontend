import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  const WishlistRepositoryImpl(this._remoteDataSource);

  final WishlistRemoteDataSource _remoteDataSource;

  @override
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>> getWishlist() async {
    try {
      final result = await _remoteDataSource.getWishlist();
      return Success((
        items: result.items.map((dto) => dto.toEntity()).toList(),
        summary: result.summary,
      ));
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '찜 목록을 불러오지 못했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<void>> addWishlist(int productId) async {
    try {
      await _remoteDataSource.addWishlist(productId);
      return const Success(null);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '찜 추가에 실패했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<void>> removeWishlist(int productId) async {
    try {
      await _remoteDataSource.removeWishlist(productId);
      return const Success(null);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '찜 삭제에 실패했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<bool>> checkWishlist(int productId) async {
    try {
      final isWishlisted = await _remoteDataSource.checkWishlist(productId);
      return Success(isWishlisted);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '찜 여부 확인에 실패했습니다.', cause: error),
      );
    }
  }
}
