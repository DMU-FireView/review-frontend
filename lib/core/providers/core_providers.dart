import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final authTokenStoreProvider = NotifierProvider<AuthTokenStore, bool>(
  AuthTokenStore.new,
);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authTokenStoreProvider);
});

final nicknameProvider = Provider<String?>((ref) {
  ref.watch(authTokenStoreProvider);
  return ref.read(authTokenStoreProvider.notifier).nickname;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(appConfigProvider),
    tokenStore: ref.read(authTokenStoreProvider.notifier),
  );
});
