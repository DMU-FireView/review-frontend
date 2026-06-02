import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';

void main() {
  testWidgets(
    'opens product detail by tapping the grid card without a price CTA',
    (tester) async {
      final router = GoRouter(
        initialLocation: RoutePaths.home,
        routes: [
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) => Scaffold(
              body: SizedBox(
                width: 360,
                height: 460,
                child: SearchProductCard(product: _product),
              ),
            ),
          ),
          GoRoute(
            path: RoutePaths.productDetail,
            name: RouteNames.productDetail,
            builder: (context, state) =>
                Text('product ${state.pathParameters['id']}'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [isLoggedInProvider.overrideWithValue(false)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('최저가 보기'), findsNothing);

      await tester.tap(find.byType(SearchProductCard));
      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, '/product/7');
      expect(find.text('product 7'), findsOneWidget);
    },
  );
}

const _product = SearchResultProduct(
  id: 7,
  name: '테스트 상품',
  imageUrl: 'https://example.com/product.png',
  price: 12000,
  category: 'ELECTRONICS',
  categoryDisplayName: '모바일/태블릿',
  avgRti: 83,
  rtiGrade: 'A',
  rtiColor: '#16A34A',
  reviewCount: 26,
  avgRating: 4.5,
  platform: 'NAVER',
);
