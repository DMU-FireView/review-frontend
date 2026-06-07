import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remoteDataSource);

  final CartRemoteDataSource _remoteDataSource;

  @override
  Future<Result<({List<CartItem> items, CartSummary summary})>> getCart() async {
    try {
      final result = await _remoteDataSource.getCart();
      return Success((
        items: result.items.map((dto) => dto.toEntity()).toList(),
        summary: result.summary,
      ));
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(Failure(message: '장바구니를 불러오지 못했습니다.', cause: e));
    }
  }

  @override
  Future<Result<void>> addItem(int productId, {int quantity = 1}) async {
    try {
      await _remoteDataSource.addItem(productId, quantity: quantity);
      return const Success(null);
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(Failure(message: '장바구니 추가에 실패했습니다.', cause: e));
    }
  }

  @override
  Future<Result<void>> updateQuantity(int productId, int quantity) async {
    try {
      await _remoteDataSource.updateQuantity(productId, quantity);
      return const Success(null);
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(Failure(message: '수량 변경에 실패했습니다.', cause: e));
    }
  }

  @override
  Future<Result<void>> removeItem(int productId) async {
    try {
      await _remoteDataSource.removeItem(productId);
      return const Success(null);
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(Failure(message: '상품 삭제에 실패했습니다.', cause: e));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _remoteDataSource.clearCart();
      return const Success(null);
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(Failure(message: '장바구니 비우기에 실패했습니다.', cause: e));
    }
  }
}
