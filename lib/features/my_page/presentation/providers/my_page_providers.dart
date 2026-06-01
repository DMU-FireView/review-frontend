import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:re_view_front/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:re_view_front/features/my_page/domain/repositories/my_page_repository.dart';
import 'package:re_view_front/features/my_page/domain/usecases/get_my_profile_use_case.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_view_model.dart';

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>((ref) {
  return MyPageRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  return MyPageRepositoryImpl(ref.watch(myPageRemoteDataSourceProvider));
});

final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCase>((ref) {
  return GetMyProfileUseCase(ref.watch(myPageRepositoryProvider));
});

final myPageViewModelProvider =
    NotifierProvider.autoDispose<MyPageViewModel, MyPageState>(
      MyPageViewModel.new,
    );
