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

    return MaterialApp.router(theme: AppTheme.light, routerConfig: router);
  }

  testWidgets('renders mock search results for a matching query', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('크림'));
    await tester.pumpAndSettle();

    expect(find.text('"크림" 검색 결과'), findsOneWidget);
    expect(find.text('세라 수분 장벽 크림 80ml'), findsOneWidget);
    expect(find.text('관련도순'), findsOneWidget);
    expect(find.textContaining('RTI 90+'), findsOneWidget);
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
    await tester.pumpWidget(buildSubject('크림'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '가전');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.search);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['q'],
      '가전',
    );
    expect(find.text('"가전" 검색 결과'), findsOneWidget);
  });
}
