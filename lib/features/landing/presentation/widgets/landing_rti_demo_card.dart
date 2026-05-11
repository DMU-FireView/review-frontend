import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';

class LandingRtiDemoCard extends StatelessWidget {
  const LandingRtiDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TrustBadgeRow(),
          SizedBox(height: AppSpacing.md),
          _ProductInfoRow(),
          SizedBox(height: AppSpacing.md),
          _RtiSummarySection(),
          SizedBox(height: AppSpacing.md),
          _RtiDisclaimer(),
        ],
      ),
    );
  }
}

class _TrustBadgeRow extends StatelessWidget {
  const _TrustBadgeRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.shield, color: AppColors.primary, size: 18),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          '신뢰 높음',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            'RTI 신뢰도 92%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.headphones,
              size: 48,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(child: _ProductDetails()),
        ],
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOUNDPRO ANC 노이즈캔슬링 헤드폰 Pro 화이트',
          style: AppTextStyles.labelLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '89,000원',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: [
            ...List.generate(
              4,
              (_) => const Icon(
                Icons.star,
                color: Color(0xFFFBBF24),
                size: 14,
              ),
            ),
            const Icon(
              Icons.star_half,
              color: Color(0xFFFBBF24),
              size: 14,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '4.8',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '리뷰 1,306',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ],
    );
  }
}

class _RtiSummarySection extends StatelessWidget {
  const _RtiSummarySection();

  static const _metrics = [
    _RtiMetric(
      icon: Icons.verified_user_outlined,
      label: '신뢰 높음',
      value: '상위 8%',
      color: AppColors.success,
    ),
    _RtiMetric(
      icon: Icons.trending_down,
      label: '광고 패턴 낮음',
      value: '위험도 12%',
      color: AppColors.primary,
    ),
    _RtiMetric(
      icon: Icons.chat_bubble_outline,
      label: '반복 문구 적음',
      value: '반복도 9%',
      color: AppColors.primary,
    ),
    _RtiMetric(
      icon: Icons.check_circle_outline,
      label: '이상 징후 없음',
      value: '정상',
      color: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Re:view 분석 요약',
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (final metric in _metrics)
                Expanded(child: _RtiMetricTile(metric: metric)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RtiMetric {
  const _RtiMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _RtiMetricTile extends StatelessWidget {
  const _RtiMetricTile({required this.metric});

  final _RtiMetric metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(metric.icon, color: metric.color, size: 24),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          metric.label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          metric.value,
          style: AppTextStyles.caption.copyWith(
            color: metric.color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RtiDisclaimer extends StatelessWidget {
  const _RtiDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            '실제 사용자 리뷰를 기반으로 분석하여 광고성/조작 신호는 필터링되어 분석에 반영됩니다.',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}
