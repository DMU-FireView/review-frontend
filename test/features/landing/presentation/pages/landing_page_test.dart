import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/landing/presentation/pages/landing_page.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

void main() {
  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: RoutePaths.landing,
      routes: [
        GoRoute(
          path: RoutePaths.landing,
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const Scaffold(body: Text('home page')),
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
          GetHomeDashboardUseCase(_HomeRepositoryFake()),
        ),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  testWidgets('uses a lighter backdrop overlay', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container && widget.color == const Color(0x660F172A),
      ),
      findsOneWidget,
    );
  });

  testWidgets('clips the background home page behind the landing card', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final homePage = find.byType(HomePage);
    expect(homePage, findsOneWidget);
    expect(
      find.ancestor(of: homePage, matching: find.byType(ClipRect)),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: homePage,
        matching: find.byType(AppNetworkImagePlaceholderScope),
      ),
      findsOneWidget,
    );
  });
}

class _HomeRepositoryFake implements HomeRepository {
  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    return const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    );
  }
}
