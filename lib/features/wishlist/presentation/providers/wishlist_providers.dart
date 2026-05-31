import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:re_view_front/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/check_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_view_model.dart';

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((
  ref,
) {
  return WishlistRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(ref.watch(wishlistRemoteDataSourceProvider));
});

final getWishlistUseCaseProvider = Provider<GetWishlistUseCase>((ref) {
  return GetWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final toggleWishlistUseCaseProvider = Provider<ToggleWishlistUseCase>((ref) {
  return ToggleWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final checkWishlistUseCaseProvider = Provider<CheckWishlistUseCase>((ref) {
  return CheckWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(WishlistViewModel.new);

final wishlistItemCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return 0;
  final result = await ref.read(getWishlistUseCaseProvider)();
  return result.when(success: (data) => data.items.length, failure: (_) => 0);
});

final wishlistProductIdsProvider = FutureProvider.autoDispose<Set<int>>((
  ref,
) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return <int>{};
  final result = await ref.read(getWishlistUseCaseProvider)();
  return result.when(
    success: (data) => data.items.map((item) => item.productId).toSet(),
    failure: (_) => <int>{},
  );
});

final wishlistButtonProvider =
    AsyncNotifierProvider.family<WishlistButtonNotifier, bool, int>(
      WishlistButtonNotifier.new,
    );

class WishlistButtonNotifier extends AsyncNotifier<bool> {
  WishlistButtonNotifier(this._productId);

  final int _productId;
  bool _isToggling = false;

  @override
  Future<bool> build() async {
    final productIds = await ref.watch(wishlistProductIdsProvider.future);
    if (productIds.contains(_productId)) return true;

    final result = await ref.read(checkWishlistUseCaseProvider)(_productId);
    return result.when(success: (v) => v, failure: (_) => false);
  }

  Future<void> toggle() async {
    if (_isToggling) return;

    final current = state.value ?? false;
    _isToggling = true;

    final toggleUseCase = ref.read(toggleWishlistUseCaseProvider);
    final result = current
        ? await toggleUseCase.remove(_productId)
        : await toggleUseCase.add(_productId);

    if (!ref.mounted) return;
    _isToggling = false;
    result.when(
      success: (_) {
        state = AsyncData(!current);
        ref.invalidate(wishlistItemCountProvider);
        ref.invalidate(wishlistProductIdsProvider);
      },
      failure: (failure) {
        if (!current && failure.code == 'WISHLIST_ALREADY_EXISTS') {
          state = const AsyncData(true);
          ref.invalidate(wishlistItemCountProvider);
          ref.invalidate(wishlistProductIdsProvider);
          return;
        }
        state = AsyncData(current);
      },
    );
  }
}
