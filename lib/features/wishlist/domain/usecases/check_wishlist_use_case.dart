import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';

class CheckWishlistUseCase {
  const CheckWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<Result<bool>> call(int productId) => _repository.checkWishlist(productId);
}
