import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:re_view_front/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
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

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(WishlistViewModel.new);
