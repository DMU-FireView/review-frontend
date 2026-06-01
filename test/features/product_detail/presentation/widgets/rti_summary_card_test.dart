import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';

void main() {
  testWidgets('uses Korean wording for high repetition instead of hanja', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: RtiSummaryCard(
            rtiSummary: const RtiSummary(
              rtiScore: 50,
              rtiLabel: '주의',
              rtiSubLabel: '확인 필요',
              realReviewRatio: 0.5,
              realReviewLabel: '보통',
              adSuspicionRatio: 0.2,
              adSuspicionLabel: '높음',
              repetitionRatio: 0.4,
              repetitionLabel: '높음',
              summaryMessage: '반복 표현이 확인됩니다.',
              analyzedReviewCount: 10,
            ),
            onDetailPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('반복 표현 多'), findsNothing);
    expect(find.text('반복 표현 많음'), findsOneWidget);
  });
}
