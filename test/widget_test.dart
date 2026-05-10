import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/app/app.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';

void main() {
  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        getHomeDashboardUseCaseProvider.overrideWithValue(
          GetHomeDashboardUseCase(const _HomeRepositoryFake()),
        ),
      ],
      child: const ReViewApp(),
    );
  }

  testWidgets('shows home page on initial route', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Re:view'), findsOneWidget);
    expect(find.text('로그인'), findsWidgets);
    expect(find.byType(HeroBannerCarousel), findsOneWidget);
  });

  testWidgets('navigates to login route from home page', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('로그인').first);
    await tester.pumpAndSettle();

    expect(find.text('Re:view에 로그인'), findsOneWidget);
  });
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake();

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    return const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    );
  }
}
