import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';

void main() {
  late GoRouter router;

  Widget buildSubject() {
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

    return MaterialApp.router(theme: AppTheme.light, routerConfig: router);
  }

  testWidgets('renders home hero and RTI sections', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Re:view'), findsOneWidget);
    expect(find.text('리뷰가 증명하는 여름 준비'), findsOneWidget);
    expect(find.text('쿨썸머 인기템 모음'), findsOneWidget);
    expect(find.text('Re:view가 더 믿을 수 있는 이유'), findsOneWidget);
    expect(find.text('추천 상품 API 연결 대기 중'), findsOneWidget);
    expect(find.text('지금 많이 찾는 키워드'), findsNothing);
    expect(find.text('92% 신뢰도'), findsNothing);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('moves to login from benefit CTA', (tester) async {
    await tester.pumpWidget(buildSubject());

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

    expect(find.text('쿨썸머 인기템 모음'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
