import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class LandingHeroSection extends StatelessWidget {
  const LandingHeroSection({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
    super.key,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  static const _features = [
    (Icons.shield_outlined, 'RTI 기반'),
    (Icons.bar_chart_outlined, '광고성 패턴 분석'),
    (Icons.list_alt_outlined, '판별 근거 제공'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ServiceBadge(),
        const SizedBox(height: AppSpacing.lg),
        _Headline(),
        const SizedBox(height: AppSpacing.md),
        Text(
          '상품별 리뷰를 분석하고, RTI로 판단한 신뢰 지수를 제공해\n더 믿을 수 있는 구매 결정을 도와드려요.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (icon, label) in _features)
              _FeatureChip(icon: icon, label: label),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _CtaRow(
          onStartPressed: onStartPressed,
          onRtiInfoPressed: onRtiInfoPressed,
        ),
        const SizedBox(height: AppSpacing.lg),
        _CloseHint(),
      ],
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: [
        const Icon(Icons.shield, color: AppColors.primary, size: 14),
        Text(
          'RE:VIEW TRUST COMMERCE',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.headlineSmall,
        children: const [
          TextSpan(text: '가짜 리뷰에 흔들리지 않는\n더 똑똑한 쇼핑, '),
          TextSpan(
            text: 'Re:view',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaRow extends StatelessWidget {
  const _CtaRow({required this.onStartPressed, required this.onRtiInfoPressed});

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(
          height: 52,
          child: AppButton(label: '시작하기', onPressed: onStartPressed),
        ),
        SizedBox(
          height: 52,
          child: AppButton(
            label: 'RTI 알아보기',
            onPressed: onRtiInfoPressed,
            variant: AppButtonVariant.outlined,
          ),
        ),
      ],
    );
  }
}

class _CloseHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: [
        const Icon(Icons.lock_outline, size: 13, color: AppColors.textTertiary),
        Text('언제든 닫고 홈으로 이동할 수 있어요', style: AppTextStyles.caption),
      ],
    );
  }
}
