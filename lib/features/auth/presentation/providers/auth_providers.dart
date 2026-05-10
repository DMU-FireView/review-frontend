import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:re_view_front/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';
import 'package:re_view_front/features/auth/domain/usecases/login_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/signup_use_case.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_view_model.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_view_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStore: ref.watch(authTokenStoreProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

final signupViewModelProvider = NotifierProvider<SignupViewModel, SignupState>(
  SignupViewModel.new,
);
