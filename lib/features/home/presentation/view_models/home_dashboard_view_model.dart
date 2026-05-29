import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';

class HomeDashboardViewModel extends Notifier<HomeDashboardState> {
  late final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  @override
  HomeDashboardState build() {
    _getHomeDashboardUseCase = ref.watch(getHomeDashboardUseCaseProvider);
    ref.watch(isLoggedInProvider); // 로그인/로그아웃 시 provider 재빌드 → 데이터 재fetch
    Future.microtask(load);
    return const HomeDashboardLoading();
  }

  Future<void> load() async {
    if (!ref.mounted) {
      return;
    }

    state = const HomeDashboardLoading();

    final result = await _getHomeDashboardUseCase();
    if (!ref.mounted) {
      return;
    }

    state = result.when(
      success: (dashboard) => dashboard.isEmpty
          ? const HomeDashboardEmpty()
          : HomeDashboardSuccess(dashboard),
      failure: (failure) => failure.statusCode == 401
          ? const HomeDashboardEmpty()
          : HomeDashboardFailure(failure),
    );
  }

  Future<void> refresh() => load();
}
