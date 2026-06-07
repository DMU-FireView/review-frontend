import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';

class ToggleWishlistUseCase {
  const ToggleWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<Result<void>> add(int productId) => _repository.addWishlist(productId);
  Future<Result<void>> remove(int productId) => _repository.removeWishlist(productId);
}
