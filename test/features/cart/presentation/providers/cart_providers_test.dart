import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';

void main() {
  test(
    'returns empty cart state without calling cart APIs when logged out',
    () async {
      final repository = _FakeCartRepository();
      final container = _buildContainer(
        repository: repository,
        isLoggedIn: false,
      );
      addTearDown(container.dispose);

      final itemCount = await container.read(cartItemCountProvider.future);
      final productIds = await container.read(cartProductIdsProvider.future);
      final inCart = await container.read(cartButtonProvider(8).future);
      await container.read(cartButtonProvider(8).notifier).add();

      expect(itemCount, 0);
      expect(productIds, isEmpty);
      expect(inCart, isFalse);
      expect(repository.getCartCalls, 0);
      expect(repository.addItemCalls, 0);
    },
  );

  test('uses one cart snapshot for count and product button states', () async {
    final repository = _FakeCartRepository(items: [_cartItem(productId: 8)]);
    final container = _buildContainer(repository: repository, isLoggedIn: true);
    addTearDown(container.dispose);

    final itemCount = await container.read(cartItemCountProvider.future);
    final savedProduct = await container.read(cartButtonProvider(8).future);
    final unsavedProduct = await container.read(cartButtonProvider(18).future);

    expect(itemCount, 1);
    expect(savedProduct, isTrue);
    expect(unsavedProduct, isFalse);
    expect(repository.getCartCalls, 1);
  });
}

ProviderContainer _buildContainer({
  required _FakeCartRepository repository,
  required bool isLoggedIn,
}) {
  return ProviderContainer(
    overrides: [
      isLoggedInProvider.overrideWithValue(isLoggedIn),
      cartRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

class _FakeCartRepository implements CartRepository {
  _FakeCartRepository({this.items = const []});

  final List<CartItem> items;
  int getCartCalls = 0;
  int addItemCalls = 0;

  @override
  Future<Result<({List<CartItem> items, CartSummary summary})>>
  getCart() async {
    getCartCalls += 1;
    return Success((
      items: items,
      summary: const CartSummary(
        totalProductPrice: 0,
        shippingFee: 0,
        discountAmount: 0,
        totalPayment: 0,
      ),
    ));
  }

  @override
  Future<Result<void>> addItem(int productId, {int quantity = 1}) async {
    addItemCalls += 1;
    return const FailureResult(Failure(message: 'unexpected add call'));
  }

  @override
  Future<Result<void>> updateQuantity(int productId, int quantity) async {
    return const FailureResult(Failure(message: 'unexpected update call'));
  }

  @override
  Future<Result<void>> removeItem(int productId) async {
    return const FailureResult(Failure(message: 'unexpected remove call'));
  }

  @override
  Future<Result<void>> clearCart() async {
    return const FailureResult(Failure(message: 'unexpected clear call'));
  }
}

CartItem _cartItem({required int productId}) {
  return CartItem(
    cartItemId: productId,
    productId: productId,
    name: '상품',
    imageUrl: 'https://example.com/product.png',
    price: 1000,
    quantity: 1,
    avgRti: 80,
    rtiGrade: 'A',
    rtiColor: '#2563EB',
    trustLevel: '높음',
    shippingFee: 0,
  );
}
