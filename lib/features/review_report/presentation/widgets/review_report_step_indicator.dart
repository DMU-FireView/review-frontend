import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

enum ReportStep { target, reason, detail, submit }

class ReviewReportStepIndicator extends StatelessWidget {
  const ReviewReportStepIndicator({super.key, required this.currentStep});

  final ReportStep currentStep;

  @override
  Widget build(BuildContext context) {
    const items = <(String, String)>[
      ('대상 확인', '상품과 리뷰 정보 확인'),
      ('신고 사유', '문제 유형 선택'),
      ('상세 근거', '추가 설명 입력'),
      ('접수 완료', '검토 상태 추적'),
    ];

    final activeIndex = currentStep.index;
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _StepItem(
              number: i + 1,
              title: items[i].$1,
              subtitle: items[i].$2,
              state: i == activeIndex
                  ? _StepState.active
                  : i < activeIndex
                  ? _StepState.done
                  : _StepState.upcoming,
            ),
          ),
          if (i < items.length - 1) const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

enum _StepState { upcoming, active, done }

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final int number;
  final String title;
  final String subtitle;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final isActive = state == _StepState.active;
    final isDone = state == _StepState.done;

    final borderColor = isActive ? AppColors.primary : AppColors.border;
    final numberBg = isActive
        ? AppColors.primary
        : isDone
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.background;
    final numberFg = isActive
        ? Colors.white
        : isDone
        ? AppColors.primary
        : AppColors.textTertiary;
    final titleColor = (isActive || isDone)
        ? AppColors.textPrimary
        : AppColors.textTertiary;
    final subtitleColor = isActive
        ? AppColors.textSecondary
        : AppColors.textTertiary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isActive ? 1.5 : 1),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: numberBg, shape: BoxShape.circle),
            child: isDone
                ? Icon(Icons.check, size: 16, color: numberFg)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: numberFg,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: subtitleColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
