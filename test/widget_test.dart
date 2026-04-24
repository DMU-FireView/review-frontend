import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/app.dart';

void main() {
  testWidgets('shows landing page on initial route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReViewApp()));
    await tester.pumpAndSettle();

    expect(find.text('Re:view'), findsOneWidget);
    expect(find.text('로그인'), findsWidgets);
    expect(find.text('쿨썸머 인기템 모음'), findsOneWidget);
  });

  testWidgets('navigates to login route from landing page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReViewApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('로그인').first);
    await tester.pumpAndSettle();

    expect(find.text('Re:view에 로그인'), findsOneWidget);
  });
}
