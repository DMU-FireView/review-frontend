import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:re_view_front/features/cart/domain/usecases/update_cart_use_case.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';

class CartViewModel extends Notifier<CartState> {
  late final GetCartUseCase _getCartUseCase;
  late final UpdateCartUseCase _updateCartUseCase;

  @override
  CartState build() {
    _getCartUseCase = ref.watch(getCartUseCaseProvider);
    _updateCartUseCase = ref.watch(updateCartUseCaseProvider);
    return const CartInitial();
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    state = const CartLoading();

    final result = await _getCartUseCase();

    if (!ref.mounted) return;
    state = result.when(
      success: (data) {
        if (data.items.isEmpty) return const CartEmpty();
        final allIds = data.items.map((i) => i.productId).toSet();
        return CartSuccess(
          items: data.items,
          summary: data.summary,
          selectedIds: allIds,
        );
      },
      failure: CartFailure.new,
    );
  }

  void toggleSelectAll() {
    final current = state;
    if (current is! CartSuccess) return;
    state = current.isAllSelected
        ? current.copyWith(selectedIds: {})
        : current.copyWith(
            selectedIds: current.items.map((i) => i.productId).toSet(),
          );
  }

  void toggleSelectItem(int productId) {
    final current = state;
    if (current is! CartSuccess) return;
    final ids = Set<int>.from(current.selectedIds);
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    state = current.copyWith(selectedIds: ids);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final current = state;
    if (current is! CartSuccess) return;
    if (quantity < 1) return;

    state = current.copyWith(
      updatingProductIds: {...current.updatingProductIds, productId},
    );

    final result = await _updateCartUseCase.updateQuantity(productId, quantity);

    if (!ref.mounted) return;
    result.when(
      success: (_) => load(),
      failure: (_) {
        if (state is CartSuccess) {
          final s = state as CartSuccess;
          state = s.copyWith(
            updatingProductIds: s.updatingProductIds.difference({productId}),
          );
        }
      },
    );
  }

  Future<void> removeItem(int productId) async {
    final current = state;
    if (current is! CartSuccess) return;

    state = current.copyWith(
      updatingProductIds: {...current.updatingProductIds, productId},
    );

    final result = await _updateCartUseCase.remove(productId);

    if (!ref.mounted) return;
    result.when(
      success: (_) => load(),
      failure: (_) {
        if (state is CartSuccess) {
          final s = state as CartSuccess;
          state = s.copyWith(
            updatingProductIds: s.updatingProductIds.difference({productId}),
          );
        }
      },
    );
  }

  Future<void> removeSelected() async {
    final current = state;
    if (current is! CartSuccess) return;

    state = current.copyWith(updatingProductIds: Set.from(current.selectedIds));

    for (final productId in current.selectedIds) {
      await _updateCartUseCase.remove(productId);
    }

    if (!ref.mounted) return;
    load();
  }
}
