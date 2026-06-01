import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';

class WishlistViewModel extends Notifier<WishlistState> {
  late final GetWishlistUseCase _getWishlistUseCase;
  late final ToggleWishlistUseCase _toggleWishlistUseCase;

  @override
  WishlistState build() {
    _getWishlistUseCase = ref.watch(getWishlistUseCaseProvider);
    _toggleWishlistUseCase = ref.watch(toggleWishlistUseCaseProvider);
    return const WishlistInitial();
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    if (!ref.read(isLoggedInProvider)) {
      state = const WishlistEmpty();
      return;
    }

    state = const WishlistLoading();

    final result = await _getWishlistUseCase();

    if (!ref.mounted) return;
    state = result.when(
      success: (data) => data.items.isEmpty
          ? const WishlistEmpty()
          : WishlistSuccess(items: data.items, summary: data.summary),
      failure: WishlistFailure.new,
    );
  }

  Future<void> removeItem(int productId) async {
    if (!ref.read(isLoggedInProvider)) return;

    final current = state;
    if (current is! WishlistSuccess) return;

    state = current.copyWith(
      togglingProductIds: {...current.togglingProductIds, productId},
    );

    final result = await _toggleWishlistUseCase.remove(productId);

    if (!ref.mounted) return;

    result.when(
      success: (_) => load(),
      failure: (failure) {
        if (state is WishlistSuccess) {
          final s = state as WishlistSuccess;
          state = s.copyWith(
            togglingProductIds: s.togglingProductIds.difference({productId}),
          );
        }
      },
    );
  }
}
