import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class LoginValuePanel extends StatelessWidget {
  const LoginValuePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoginBadge(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '내 관심 상품의 리뷰 신뢰도를\n계속 추적하세요.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '로그인하면 저장한 상품, 신뢰 필터 설정, 분석 피드백 내역을 한 계정에서 이어서 관리할 수 있습니다.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          const _TrustSummaryCard(),
          const SizedBox(height: AppSpacing.lg),
          const _LoginBenefitGrid(),
        ],
      ),
    );
  }
}

class _LoginBadge extends StatelessWidget {
  const _LoginBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          '안전한 쇼핑을 위한 로그인',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TrustSummaryCard extends StatelessWidget {
  const _TrustSummaryCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '최근 확인한 상품',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '로그인 후 저장 상품과 분석 기록을 불러옵니다.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const _TrackingBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const _SavedProductSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _TrackingBadge extends StatelessWidget {
  const _TrackingBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          'RTI 계속 추적',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SavedProductSkeleton extends StatelessWidget {
  const _SavedProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useHorizontal = constraints.maxWidth >= 560;
        final thumbnail = Stack(
          clipBehavior: Clip.none,
          children: const [
            _SkeletonBox(width: 150, height: 150, radius: 22),
            Positioned(right: -10, top: 16, child: _ScoreSkeleton()),
          ],
        );
        final details = const _ProductDetailSkeleton();

        if (!useHorizontal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              const SizedBox(height: AppSpacing.lg),
              details,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            thumbnail,
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SkeletonBox(width: 300, height: 20, radius: 8),
        SizedBox(height: AppSpacing.sm),
        _SkeletonBox(width: 230, height: 14, radius: 7),
        SizedBox(height: AppSpacing.lg),
        _SkeletonMetricRow(label: '텍스트', widthFactor: 0.64),
        SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(label: '행동', widthFactor: 0.78),
        SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(label: '구매맥락', widthFactor: 0.86),
      ],
    );
  }
}

class _SkeletonMetricRow extends StatelessWidget {
  const _SkeletonMetricRow({required this.label, required this.widthFactor});

  final String label;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              const _SkeletonBox(
                width: double.infinity,
                height: 7,
                radius: 999,
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const _SkeletonBox(width: 28, height: 12, radius: 6),
      ],
    );
  }
}

class _ScoreSkeleton extends StatelessWidget {
  const _ScoreSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary),
      ),
      child: const SizedBox(
        width: 44,
        height: 44,
        child: Center(child: _SkeletonBox(width: 20, height: 12, radius: 6)),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FA),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE3E8F2)),
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F7FC), Color(0xFFE9EEF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: width == 150
          ? Center(
              child: Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textTertiary.withValues(alpha: 0.7),
                size: 42,
              ),
            )
          : null,
    );
  }
}

class _LoginBenefitGrid extends StatelessWidget {
  const _LoginBenefitGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        number: '1',
        title: '저장 상품 관리',
        body: '관심 상품을 모아두고 RTI 변화 위협 신호를 확인합니다.',
      ),
      (
        number: '2',
        title: '개인 신뢰 필터',
        body: '위험 리뷰 숨김, 최소 RTI 기준 등 나에게 맞는 필터를 유지합니다.',
      ),
      (number: '3', title: '분석 피드백 추적', body: '신고와 피드백 처리 상태를 한곳에서 확인합니다.'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in items)
            _BenefitCard(
              number: item.number,
              title: item.title,
              body: item.body,
            ),
        ];

        if (!useRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
