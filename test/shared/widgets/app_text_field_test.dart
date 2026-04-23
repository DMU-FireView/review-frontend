import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/shared/widgets/app_text_field.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders label and forwards text changes', (tester) async {
    var value = '';

    await tester.pumpWidget(
      buildSubject(
        AppTextField(
          labelText: '이메일',
          hintText: 'email@example.com',
          onChanged: (text) => value = text,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'review@example.com');

    expect(find.text('이메일'), findsOneWidget);
    expect(find.text('email@example.com'), findsOneWidget);
    expect(value, 'review@example.com');
  });
}
