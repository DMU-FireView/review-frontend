import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  const GetWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>> call() =>
      _repository.getWishlist();
}
