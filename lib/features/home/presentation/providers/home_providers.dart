import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/data/datasources/home_remote_data_source.dart';
import 'package:re_view_front/features/home/data/repositories/home_repository_impl.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_view_model.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
});

final getHomeDashboardUseCaseProvider = Provider<GetHomeDashboardUseCase>((
  ref,
) {
  return GetHomeDashboardUseCase(ref.watch(homeRepositoryProvider));
});

final homeDashboardViewModelProvider =
    NotifierProvider.autoDispose<HomeDashboardViewModel, HomeDashboardState>(
      HomeDashboardViewModel.new,
    );
