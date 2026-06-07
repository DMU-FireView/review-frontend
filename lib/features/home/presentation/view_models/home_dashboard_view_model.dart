import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';

class HomeDashboardViewModel extends Notifier<HomeDashboardState> {
  int _loadRequestId = 0;

  @override
  HomeDashboardState build() {
    // ref.watch 대신 ref.listen 사용 — 로그인 상태 변화 시 notifier 재빌드 없이 load()만 재호출
    ref.listen<bool>(isLoggedInProvider, (_, __) => Future.microtask(load));
    Future.microtask(load);
    return const HomeDashboardLoading();
  }

  Future<void> load() async {
    if (!ref.mounted) return;

    final requestId = ++_loadRequestId;
    state = const HomeDashboardLoading();

    final result = await ref.read(getHomeDashboardUseCaseProvider)();
    if (!ref.mounted || requestId != _loadRequestId) return;

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
