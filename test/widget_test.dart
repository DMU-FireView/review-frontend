import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/app.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';

void main() {
  testWidgets('shows home page on initial route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReViewApp()));
    await tester.pumpAndSettle();

    expect(find.text('Re:view'), findsOneWidget);
    expect(find.text('로그인'), findsWidgets);
    expect(find.byType(HeroBannerCarousel), findsOneWidget);
  });

  testWidgets('navigates to login route from home page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReViewApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('로그인').first);
    await tester.pumpAndSettle();

    expect(find.text('Re:view에 로그인'), findsOneWidget);
  });
}
