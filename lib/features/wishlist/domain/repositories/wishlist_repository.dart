import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';

abstract interface class WishlistRepository {
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>> getWishlist();
  Future<Result<void>> addWishlist(int productId);
  Future<Result<void>> removeWishlist(int productId);
  Future<Result<bool>> checkWishlist(int productId);
}
