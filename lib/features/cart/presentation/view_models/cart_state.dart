import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  const CartSuccess({
    required this.items,
    required this.summary,
    this.selectedIds = const {},
    this.updatingProductIds = const {},
  });

  final List<CartItem> items;
  final CartSummary summary;
  final Set<int> selectedIds;
  final Set<int> updatingProductIds;

  bool get isAllSelected =>
      items.isNotEmpty && items.every((i) => selectedIds.contains(i.productId));

  List<CartItem> get selectedItems =>
      items.where((i) => selectedIds.contains(i.productId)).toList();

  CartSummary get selectedSummary {
    final selected = selectedItems;
    final total = selected.fold(0, (sum, i) => sum + i.price * i.quantity);
    final shipping = selected.every((i) => i.isFreeShipping) ? 0 : summary.shippingFee;
    return CartSummary(
      totalProductPrice: total,
      shippingFee: shipping,
      discountAmount: summary.discountAmount,
      totalPayment: total + shipping - summary.discountAmount,
      expectedPoint: summary.expectedPoint,
      appliedCouponName: summary.appliedCouponName,
      appliedCouponDiscount: summary.appliedCouponDiscount,
    );
  }

  CartSuccess copyWith({
    List<CartItem>? items,
    CartSummary? summary,
    Set<int>? selectedIds,
    Set<int>? updatingProductIds,
  }) {
    return CartSuccess(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      selectedIds: selectedIds ?? this.selectedIds,
      updatingProductIds: updatingProductIds ?? this.updatingProductIds,
    );
  }
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartFailure extends CartState {
  const CartFailure(this.failure);

  final Failure failure;
}
