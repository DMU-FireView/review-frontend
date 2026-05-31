import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/check_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

void main() {
  test(
    'wishlist buttons reuse the bulk wishlist ids without per-card checks',
    () async {
      final repository = _WishlistRepositoryFake(
        items: [_wishlistItem(1), _wishlistItem(3)],
      );
      final container = ProviderContainer(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          getWishlistUseCaseProvider.overrideWithValue(
            GetWishlistUseCase(repository),
          ),
          checkWishlistUseCaseProvider.overrideWithValue(
            CheckWishlistUseCase(repository),
          ),
          toggleWishlistUseCaseProvider.overrideWithValue(
            ToggleWishlistUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(wishlistButtonProvider(1).future), isTrue);
      expect(await container.read(wishlistButtonProvider(2).future), isFalse);
      expect(await container.read(wishlistButtonProvider(3).future), isTrue);

      expect(repository.getWishlistCalls, 1);
      expect(repository.checkWishlistCalls, isEmpty);
    },
  );
}

WishlistItem _wishlistItem(int productId) {
  return WishlistItem(
    productId: productId,
    name: 'Product $productId',
    imageUrl: '',
    price: 10000,
    category: 'category',
    categoryDisplayName: 'Category',
    avgRti: 80,
    rtiGrade: 'A',
    rtiColor: '#10B981',
    reviewCount: 10,
    avgRating: 4.5,
    isPriceDrop: false,
    isNewAlert: false,
  );
}

class _WishlistRepositoryFake implements WishlistRepository {
  _WishlistRepositoryFake({required this.items});

  final List<WishlistItem> items;
  int getWishlistCalls = 0;
  final List<int> checkWishlistCalls = [];

  @override
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>>
  getWishlist() async {
    getWishlistCalls += 1;
    return Success((
      items: items,
      summary: const WishlistSummary(
        priceDropCount: 0,
        newAlertCount: 0,
        totalReviewCount: 0,
      ),
    ));
  }

  @override
  Future<Result<bool>> checkWishlist(int productId) async {
    checkWishlistCalls.add(productId);
    return Success(items.any((item) => item.productId == productId));
  }

  @override
  Future<Result<void>> addWishlist(int productId) async {
    return const Success(null);
  }

  @override
  Future<Result<void>> removeWishlist(int productId) async {
    return const Success(null);
  }
}
