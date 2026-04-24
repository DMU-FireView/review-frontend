import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';

abstract interface class HomeRepository {
  Future<Result<DashboardSummary>> getHomeDashboard();
}
