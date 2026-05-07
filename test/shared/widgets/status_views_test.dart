import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders loading message', (tester) async {
    await tester.pumpWidget(
      buildSubject(const AppLoadingView(message: '불러오는 중')),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('불러오는 중'), findsOneWidget);
  });

  testWidgets('renders retry action on error view', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      buildSubject(
        AppErrorView(message: '잠시 후 다시 시도해주세요.', onRetry: () => retried = true),
      ),
    );

    await tester.tap(find.text('다시 시도'));

    expect(find.text('문제가 발생했어요'), findsOneWidget);
    expect(retried, isTrue);
  });

  testWidgets('renders empty state content', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        const AppEmptyView(title: '목록 없음', message: '표시할 항목이 없습니다.'),
      ),
    );

    expect(find.text('목록 없음'), findsOneWidget);
    expect(find.text('표시할 항목이 없습니다.'), findsOneWidget);
  });
}
