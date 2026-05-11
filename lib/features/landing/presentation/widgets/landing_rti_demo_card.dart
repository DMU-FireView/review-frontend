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
          _ProductSkeleton(),
          SizedBox(height: AppSpacing.md),
          _RtiSummarySkeleton(),
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
        const Icon(Icons.shield, color: AppColors.primary, size: 16),
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

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 80, height: 80, radius: AppRadius.sm),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(height: 14, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.xs),
                _SkeletonBox(width: 120, height: 14, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.sm),
                _SkeletonBox(width: 80, height: 18, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.xs),
                _SkeletonBox(width: 100, height: 12, radius: AppRadius.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RtiSummarySkeleton extends StatelessWidget {
  const _RtiSummarySkeleton();

  static const _labels = ['신뢰 높음', '광고 패턴 낮음', '반복 문구 적음', '이상 징후 없음'];
  static const _icons = [
    Icons.verified_user_outlined,
    Icons.trending_down,
    Icons.chat_bubble_outline,
    Icons.check_circle_outline,
  ];
  static const _colors = [
    AppColors.success,
    AppColors.primary,
    AppColors.primary,
    AppColors.success,
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
              Text('Re:view 분석 요약', style: AppTextStyles.labelLarge),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.info_outline,
                size: 13,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (var i = 0; i < _labels.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      Icon(_icons[i], color: _colors[i], size: 22),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        _labels[i],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      const _SkeletonBox(width: 36, height: 10, radius: AppRadius.xs),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
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
        const Icon(Icons.info_outline, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            '실제 사용자 리뷰를 기반으로 분석하여\n광고성/조작 신호는 필터링되어 분석에 반영됩니다.',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({
    this.width,
    required this.height,
    this.radius = 0,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
