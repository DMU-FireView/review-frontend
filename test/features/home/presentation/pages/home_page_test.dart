import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';

void main() {
  late GoRouter router;

  Widget buildSubject({
    Result<DashboardSummary> result = const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    ),
    bool pending = false,
  }) {
    router = GoRouter(
      initialLocation: RoutePaths.home,
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const Scaffold(body: Text('login page')),
        ),
        GoRoute(
          path: RoutePaths.signup,
          builder: (context, state) =>
              const Scaffold(body: Text('signup page')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        getHomeDashboardUseCaseProvider.overrideWithValue(
          GetHomeDashboardUseCase(_HomeRepositoryFake(result, pending)),
        ),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  testWidgets('renders home hero and RTI sections', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Re:view'), findsOneWidget);
    expect(find.byType(HeroBannerCarousel), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.text('Re:view가 더 믿을 수 있는 이유'), findsOneWidget);
    expect(find.text('추천 상품 API 연결 대기 중'), findsOneWidget);
    expect(find.text('지금 많이 찾는 키워드'), findsNothing);
    expect(find.text('92% 신뢰도'), findsNothing);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('renders loading state before dashboard resolves', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(pending: true));

    expect(find.text('홈 데이터를 불러오는 중입니다.'), findsOneWidget);
  });

  testWidgets('renders retry UI when dashboard load fails', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        result: const FailureResult<DashboardSummary>(
          Failure(message: 'network failed'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('network failed'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });

  testWidgets('moves to login from benefit CTA', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
    await tester.pumpAndSettle();

    final benefitCta = find.text('혜택 받기').first;
    await tester.tap(benefitCta);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('login page'), findsOneWidget);
  });

  testWidgets('moves to login from header CTA', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('로그인').first);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('login page'), findsOneWidget);
  });

  testWidgets('renders on mobile width without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(HeroBannerCarousel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake(this.result, this.pending);

  final Result<DashboardSummary> result;
  final bool pending;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    if (pending) {
      return Completer<Result<DashboardSummary>>().future;
    }

    return result;
  }
}
