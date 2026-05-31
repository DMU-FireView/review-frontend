import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartUseCase {
  const UpdateCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<void>> add(int productId, {int quantity = 1}) =>
      _repository.addItem(productId, quantity: quantity);

  Future<Result<void>> updateQuantity(int productId, int quantity) =>
      _repository.updateQuantity(productId, quantity);

  Future<Result<void>> remove(int productId) =>
      _repository.removeItem(productId);

  Future<Result<void>> clearAll() => _repository.clearCart();
}
