import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/reason_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';

class ReasonSelectorSection extends StatelessWidget {
  const ReasonSelectorSection({
    super.key,
    required this.selectedReasons,
    required this.onToggled,
    this.onShowCriteria,
  });

  final Set<ReportReason> selectedReasons;
  final ValueChanged<ReportReason> onToggled;
  final VoidCallback? onShowCriteria;

  static const _reasons = [
    ReportReason.fakeReview,
    ReportReason.aiGenerated,
    ReportReason.irrelevantContent,
    ReportReason.inappropriate,
  ];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '신고 사유 선택',
      description: '복수 선택 가능 · 가장 가까운 유형을 선택해주세요.',
      trailing: TextButton(
        onPressed: onShowCriteria,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          '신고 기준 보기',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 720 ? 4 : 2;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: crossAxisCount == 4 ? 1.4 : 2.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final reason in _reasons)
                ReasonCard(
                  reason: reason,
                  isSelected: selectedReasons.contains(reason),
                  onTap: () => onToggled(reason),
                ),
            ],
          );
        },
      ),
    );
  }
}
