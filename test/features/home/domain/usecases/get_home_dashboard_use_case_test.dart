import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';

void main() {
  test('returns repository dashboard result', () async {
    const dashboard = DashboardSummary(
      recommendedProducts: [],
      trendingKeywords: [],
    );
    final repository = _HomeRepositoryFake(const Success(dashboard));
    final useCase = GetHomeDashboardUseCase(repository);

    final result = await useCase();

    expect(result, isA<Success<DashboardSummary>>());
    expect((result as Success<DashboardSummary>).value, dashboard);
  });

  test('returns repository failure result', () async {
    const failure = Failure(message: 'failed');
    final repository = _HomeRepositoryFake(
      const FailureResult<DashboardSummary>(failure),
    );
    final useCase = GetHomeDashboardUseCase(repository);

    final result = await useCase();

    expect(result, isA<FailureResult<DashboardSummary>>());
    expect((result as FailureResult<DashboardSummary>).failure, failure);
  });
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake(this.result);

  final Result<DashboardSummary> result;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async => result;
}
