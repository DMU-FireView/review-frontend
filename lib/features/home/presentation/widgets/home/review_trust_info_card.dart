import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class ReviewTrustInfoCard extends StatelessWidget {
  const ReviewTrustInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useHorizontalLayout = constraints.maxWidth >= 760;

          return Padding(
            padding: EdgeInsets.all(
              context.isMobile ? AppSpacing.lg : AppSpacing.xl,
            ),
            child: useHorizontalLayout
                ? const Row(
                    children: [
                      Expanded(flex: 5, child: _TrustMain()),
                      SizedBox(width: AppSpacing.xl),
                      Expanded(flex: 6, child: _TrustFeatures()),
                    ],
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TrustMain(isCompact: true),
                      SizedBox(height: AppSpacing.lg),
                      _TrustFeatures(),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _TrustMain extends StatelessWidget {
  const _TrustMain({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isCompact ? 72 : 96,
          height: isCompact ? 72 : 96,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Color(0xFFEFF4FF),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/home/brand/RTI.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: isCompact ? 40 : 54,
            ),
          ),
        ),
        SizedBox(width: isCompact ? AppSpacing.md : AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Re:view가 더 믿을 수 있는 이유',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'RTI 리뷰 신뢰도 지수',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '광고·조작 리뷰를 필터링하고 실사용 리뷰를 분석해 신뢰도를 제공합니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustFeatures extends StatelessWidget {
  const _TrustFeatures();

  @override
  Widget build(BuildContext context) {
    const items = [
      _FeatureItem(
        iconAssetPath: 'assets/images/home/icons/icon-review-analysis.png',
        label: '실사용 리뷰 분석',
      ),
      _FeatureItem(
        iconAssetPath: 'assets/images/home/icons/icon-fraud-filter.png',
        label: '광고/조작 필터링',
      ),
      _FeatureItem(
        iconAssetPath: 'assets/images/home/icons/icon-trust-score.png',
        label: '신뢰도 점수 제공',
      ),
    ];

    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: item),
          if (item != items.last)
            Container(width: 1, height: 58, color: AppColors.border),
        ],
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.iconAssetPath, required this.label});

  final String iconAssetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 34,
          height: 34,
          child: Image.asset(
            iconAssetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
