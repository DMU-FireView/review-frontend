import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';

sealed class HomeDashboardState {
  const HomeDashboardState();

  bool get isLoading => this is HomeDashboardLoading;
  bool get isSuccess => this is HomeDashboardSuccess;
  bool get isEmpty => this is HomeDashboardEmpty;
  bool get isFailure => this is HomeDashboardFailure;
}

class HomeDashboardLoading extends HomeDashboardState {
  const HomeDashboardLoading();
}

class HomeDashboardSuccess extends HomeDashboardState {
  const HomeDashboardSuccess(this.dashboard);

  final DashboardSummary dashboard;
}

class HomeDashboardEmpty extends HomeDashboardState {
  const HomeDashboardEmpty();
}

class HomeDashboardFailure extends HomeDashboardState {
  const HomeDashboardFailure(this.failure);

  final Failure failure;
}
