import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';

class GetHomeDashboardUseCase {
  const GetHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<DashboardSummary>> call() {
    return _repository.getHomeDashboard();
  }
}
