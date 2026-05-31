import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';

sealed class WishlistState {
  const WishlistState();
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

class WishlistSuccess extends WishlistState {
  const WishlistSuccess({
    required this.items,
    required this.summary,
    this.togglingProductIds = const {},
  });

  final List<WishlistItem> items;
  final WishlistSummary summary;
  final Set<int> togglingProductIds;

  WishlistSuccess copyWith({
    List<WishlistItem>? items,
    WishlistSummary? summary,
    Set<int>? togglingProductIds,
  }) {
    return WishlistSuccess(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      togglingProductIds: togglingProductIds ?? this.togglingProductIds,
    );
  }
}

class WishlistEmpty extends WishlistState {
  const WishlistEmpty();
}

class WishlistFailure extends WishlistState {
  const WishlistFailure(this.failure);

  final Failure failure;
}
