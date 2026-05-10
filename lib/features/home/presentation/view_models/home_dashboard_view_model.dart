import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';

class HomeDashboardViewModel extends Notifier<HomeDashboardState> {
  late final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  @override
  HomeDashboardState build() {
    _getHomeDashboardUseCase = ref.watch(getHomeDashboardUseCaseProvider);
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
      failure: HomeDashboardFailure.new,
    );
  }

  Future<void> refresh() => load();
}
