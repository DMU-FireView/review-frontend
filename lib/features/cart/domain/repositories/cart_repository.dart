import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';

abstract interface class CartRepository {
  Future<Result<({List<CartItem> items, CartSummary summary})>> getCart();
  Future<Result<void>> addItem(int productId, {int quantity = 1});
  Future<Result<void>> updateQuantity(int productId, int quantity);
  Future<Result<void>> removeItem(int productId);
  Future<Result<void>> clearCart();
}
