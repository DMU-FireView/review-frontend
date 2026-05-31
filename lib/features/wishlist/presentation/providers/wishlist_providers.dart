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

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
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

final wishlistButtonProvider =
    AsyncNotifierProvider.family<WishlistButtonNotifier, bool, int>(
  WishlistButtonNotifier.new,
);

class WishlistButtonNotifier extends AsyncNotifier<bool> {
  WishlistButtonNotifier(this._productId);

  final int _productId;

  @override
  Future<bool> build() async {
    final result = await ref.read(checkWishlistUseCaseProvider)(_productId);
    return result.when(success: (v) => v, failure: (_) => false);
  }

  Future<void> toggle() async {
    final current = state.valueOrNull ?? false;
    state = AsyncData(!current);

    final toggleUseCase = ref.read(toggleWishlistUseCaseProvider);
    final result = current
        ? await toggleUseCase.remove(_productId)
        : await toggleUseCase.add(_productId);

    if (!ref.mounted) return;
    result.when(
      success: (_) {},
      failure: (_) => state = AsyncData(current),
    );
  }
}
