import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('calls onPressed when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildSubject(AppButton(label: '확인', onPressed: () => tapped = true)),
    );

    await tester.tap(find.text('확인'));

    expect(tapped, isTrue);
  });

  testWidgets('disables action and shows progress while loading', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      buildSubject(
        AppButton(label: '저장', isLoading: true, onPressed: () => tapped = true),
      ),
    );

    await tester.tap(find.text('저장'));

    expect(tapped, isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
