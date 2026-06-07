import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';

void main() {
  test('moves from loading to success when dashboard has data', () async {
    final container = _buildContainer(
      const Success(
        DashboardSummary(
          recommendedProducts: [
            DashboardProduct(
              id: '1',
              name: '상품',
              storeName: '스토어',
              price: 1000,
              imageUrl: 'https://example.com/image.png',
            ),
          ],
          trendingKeywords: [TrendingKeyword(keyword: '키워드', rank: 1)],
        ),
      ),
    );
    addTearDown(container.dispose);
    final subscription = container.listen<HomeDashboardState>(
      homeDashboardViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(
      container.read(homeDashboardViewModelProvider),
      isA<HomeDashboardLoading>(),
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(homeDashboardViewModelProvider),
      isA<HomeDashboardSuccess>(),
    );
  });

  test('moves from loading to empty when dashboard has no data', () async {
    final container = _buildContainer(
      const Success(
        DashboardSummary(recommendedProducts: [], trendingKeywords: []),
      ),
    );
    addTearDown(container.dispose);
    final subscription = container.listen<HomeDashboardState>(
      homeDashboardViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(homeDashboardViewModelProvider),
      isA<HomeDashboardEmpty>(),
    );
  });

  test('moves from loading to failure when usecase fails', () async {
    final container = _buildContainer(
      const FailureResult<DashboardSummary>(Failure(message: 'failed')),
    );
    addTearDown(container.dispose);
    final subscription = container.listen<HomeDashboardState>(
      homeDashboardViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(homeDashboardViewModelProvider);
    expect(state, isA<HomeDashboardFailure>());
    expect((state as HomeDashboardFailure).failure.message, 'failed');
  });
}

ProviderContainer _buildContainer(Result<DashboardSummary> result) {
  return ProviderContainer(
    overrides: [
      getHomeDashboardUseCaseProvider.overrideWithValue(
        GetHomeDashboardUseCase(_HomeRepositoryFake(result)),
      ),
    ],
  );
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake(this.result);

  final Result<DashboardSummary> result;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async => result;
}
