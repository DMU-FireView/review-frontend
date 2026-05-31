import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:re_view_front/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';
import 'package:re_view_front/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:re_view_front/features/cart/domain/usecases/update_cart_use_case.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_view_model.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(cartRemoteDataSourceProvider));
});

final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  return GetCartUseCase(ref.watch(cartRepositoryProvider));
});

final updateCartUseCaseProvider = Provider<UpdateCartUseCase>((ref) {
  return UpdateCartUseCase(ref.watch(cartRepositoryProvider));
});

final cartViewModelProvider =
    NotifierProvider<CartViewModel, CartState>(CartViewModel.new);

final cartItemCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return 0;
  final result = await ref.read(getCartUseCaseProvider)();
  return result.when(
    success: (data) => data.items.length,
    failure: (_) => 0,
  );
});
