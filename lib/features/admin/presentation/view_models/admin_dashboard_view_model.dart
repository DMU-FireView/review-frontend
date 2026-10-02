import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_dashboard_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_dashboard_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_dashboard_state.dart';

class AdminDashboardViewModel extends Notifier<AdminDashboardState> {
  AdminDashboardRepository get _repository =>
      ref.read(adminDashboardRepositoryProvider);

  /// 기간을 빠르게 바꿀 때 늦게 온 이전 기간 응답을 버리기 위한 번호.
  int _performanceRequest = 0;

  @override
  AdminDashboardState build() {
    Future.microtask(refresh);
    return const AdminDashboardState();
  }

  Future<void> refresh() async {
    await Future.wait([_loadSummary(), _loadPerformance()]);
  }

  Future<void> setDays(int days) async {
    if (days == state.days) return;
    state = state.copyWith(days: days);
    await _loadPerformance();
  }

  Future<void> _loadSummary() async {
    state = state.copyWith(summary: const AsyncLoading());
    final result = await _repository.getSummary();
    if (!ref.mounted) return;
    state = state.copyWith(
      summary: result.when(
        success: AsyncData.new,
        failure: (f) => AsyncError(f.message, StackTrace.current),
      ),
    );
  }

  Future<void> _loadPerformance() async {
    final request = ++_performanceRequest;
    state = state.copyWith(performance: const AsyncLoading());
    final result = await _repository.getModelPerformance(days: state.days);
    if (!ref.mounted || request != _performanceRequest) return;
    state = state.copyWith(
      performance: result.when(
        success: AsyncData.new,
        failure: (f) => AsyncError(f.message, StackTrace.current),
      ),
    );
  }
}
