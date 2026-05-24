import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';

void main() {
  late GoRouter router;

  Widget buildSubject(String query) {
    router = GoRouter(
      initialLocation: Uri(
        path: RoutePaths.search,
        queryParameters: {'q': query},
      ).toString(),
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const Scaffold(body: Text('home page')),
        ),
        GoRoute(
          path: RoutePaths.search,
          name: RouteNames.search,
          builder: (context, state) =>
              SearchResultsPage(query: state.uri.queryParameters['q'] ?? ''),
        ),
      ],
    );

    return MaterialApp.router(
      theme: AppTheme.light.copyWith(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    );
  }

  testWidgets('renders mock search results for a matching query', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    expect(find.text('이어폰'), findsWidgets);
    expect(find.text('AeroFit ANC 무선 블루투스 이어폰'), findsOneWidget);
    expect(find.text('정확도 순'), findsOneWidget);
    expect(find.textContaining('RTI 80+'), findsOneWidget);
  });

  testWidgets('renders empty state when mock search has no match', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('없는상품'));
    await tester.pumpAndSettle();

    expect(find.text('검색 결과가 없어요'), findsOneWidget);
    expect(find.text('다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.'), findsOneWidget);
  });

  testWidgets('updates route when searching again from results page', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '가전');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.search);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['q'],
      '가전',
    );
    expect(find.text('가전'), findsWidgets);
  });

  testWidgets('changes visible page size from the result toolbar dropdown', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('60개씩 보기'),
      800,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('60개씩 보기'), findsOneWidget);

    await tester.tap(find.text('60개씩 보기'));
    await tester.pumpAndSettle();

    expect(find.text('30개씩 보기'), findsOneWidget);
    expect(find.text('120개씩 보기'), findsOneWidget);

    await tester.tap(find.text('30개씩 보기').last);
    await tester.pumpAndSettle();

    expect(find.text('30개씩 보기'), findsOneWidget);
  });

  testWidgets('renders price histogram bars behind the price range control', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('price-histogram-bars')), findsOneWidget);
  });
}
