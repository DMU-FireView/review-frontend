import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_image_gallery.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

void main() {
  testWidgets('toggles wishlist through the API from the gallery button', (
    tester,
  ) async {
    final repository = _FakeWishlistRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          wishlistRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ProductImageGallery(
                  productId: 42,
                  imageUrls: ['https://example.com/product.png'],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(repository.addWishlistCalls, 1);
    expect(repository.addedProductIds, [42]);
  });
}

class _FakeWishlistRepository implements WishlistRepository {
  int getWishlistCalls = 0;
  int addWishlistCalls = 0;
  int removeWishlistCalls = 0;
  final List<int> addedProductIds = [];

  @override
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>>
  getWishlist() async {
    getWishlistCalls += 1;
    return const Success((
      items: <WishlistItem>[],
      summary: WishlistSummary(
        priceDropCount: 0,
        newAlertCount: 0,
        totalReviewCount: 0,
      ),
    ));
  }

  @override
  Future<Result<void>> addWishlist(int productId) async {
    addWishlistCalls += 1;
    addedProductIds.add(productId);
    return const Success(null);
  }

  @override
  Future<Result<void>> removeWishlist(int productId) async {
    removeWishlistCalls += 1;
    return const Success(null);
  }

  @override
  Future<Result<bool>> checkWishlist(int productId) async {
    return const FailureResult(Failure(message: 'unexpected check call'));
  }
}
