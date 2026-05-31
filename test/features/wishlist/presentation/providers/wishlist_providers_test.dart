import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

void main() {
  test('returns false without calling wishlist APIs when logged out', () async {
    final repository = _FakeWishlistRepository();
    final container = _buildContainer(
      repository: repository,
      isLoggedIn: false,
    );
    addTearDown(container.dispose);

    final isWishlisted = await container.read(wishlistButtonProvider(8).future);

    expect(isWishlisted, isFalse);
    expect(repository.getWishlistCalls, 0);
    expect(repository.checkWishlistCalls, 0);
  });

  test('uses cached wishlist ids instead of per-product check calls', () async {
    final repository = _FakeWishlistRepository(
      items: [_wishlistItem(productId: 8)],
    );
    final container = _buildContainer(repository: repository, isLoggedIn: true);
    addTearDown(container.dispose);
    final wishlistIdsSubscription = container.listen(
      wishlistProductIdsProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(wishlistIdsSubscription.close);

    final savedProduct = await container.read(wishlistButtonProvider(8).future);
    final unsavedProduct = await container.read(
      wishlistButtonProvider(18).future,
    );

    expect(savedProduct, isTrue);
    expect(unsavedProduct, isFalse);
    expect(repository.getWishlistCalls, 1);
    expect(repository.checkWishlistCalls, 0);
  });
}

ProviderContainer _buildContainer({
  required _FakeWishlistRepository repository,
  required bool isLoggedIn,
}) {
  return ProviderContainer(
    overrides: [
      isLoggedInProvider.overrideWithValue(isLoggedIn),
      wishlistRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

WishlistItem _wishlistItem({required int productId}) {
  return WishlistItem(
    productId: productId,
    name: '상품',
    imageUrl: 'https://example.com/product.png',
    price: 1000,
    category: 'general',
    categoryDisplayName: '일반',
    avgRti: 80,
    rtiGrade: 'A',
    rtiColor: '#2563EB',
    reviewCount: 10,
    avgRating: 4.5,
    isPriceDrop: false,
    isNewAlert: false,
  );
}

class _FakeWishlistRepository implements WishlistRepository {
  _FakeWishlistRepository({this.items = const []});

  final List<WishlistItem> items;
  int getWishlistCalls = 0;
  int checkWishlistCalls = 0;

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
  Future<Result<void>> addWishlist(int productId) async {
    return const Success(null);
  }

  @override
  Future<Result<void>> removeWishlist(int productId) async {
    return const Success(null);
  }

  @override
  Future<Result<bool>> checkWishlist(int productId) async {
    checkWishlistCalls += 1;
    return const FailureResult(Failure(message: 'unexpected check call'));
  }
}
