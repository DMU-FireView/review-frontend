import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class BenefitCTA extends StatelessWidget {
  const BenefitCTA({
    required this.items,
    required this.onBenefitPressed,
    super.key,
  });

  final List<BenefitData> items;
  final VoidCallback onBenefitPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.isMobile ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: context.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _children(context),
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _children(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  const Icon(
                    Icons.card_giftcard,
                    color: AppColors.primary,
                    size: 96,
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _children(BuildContext context) {
    return [
      Text('첫 구매 고객을 위한 혜택', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.xs),
      Text(
        '리뷰 기반 쇼핑을 시작하면 받을 수 있는 회원 혜택입니다.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final item in items)
            Container(
              width: 124,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      FilledButton(onPressed: onBenefitPressed, child: const Text('혜택 받기')),
    ];
  }
}
