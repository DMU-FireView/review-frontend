import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class AnalysisReportPage extends ConsumerWidget {
  const AnalysisReportPage({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailViewModelProvider(productId));
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              showCategoryNav: false,
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onMyPagePressed: () => context.go(RoutePaths.myPage),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.dashboard),
              onLogoutPressed: () =>
                  ref.read(authTokenStoreProvider.notifier).clear(),
              onNavItemPressed: (item) => context.goNamed(
                RouteNames.search,
                queryParameters: {'q': item},
              ),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              onLogoPressed: () => context.goNamed(RouteNames.home),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1200,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const _LoadingView(),
                ProductDetailFailure(:final failure) => _ErrorView(
                  message: failure.message,
                  onRetry: () => ref
                      .read(
                        productDetailViewModelProvider(productId).notifier,
                      )
                      .refresh(),
                ),
                ProductDetailSuccess(
                  :final detail,
                  :final reviews,
                  :final isAnalyzing,
                  :final safeCount,
                  :final warnCount,
                  :final dangerCount,
                ) =>
                  _ReportContent(
                    detail: detail,
                    reviews: reviews,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    onBackToProduct: () => context.goNamed(
                      RouteNames.productDetail,
                      pathParameters: {'id': productId.toString()},
                    ),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportContent extends StatelessWidget {
  const _ReportContent({
    required this.detail,
    required this.reviews,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.onBackToProduct,
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final VoidCallback onBackToProduct;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    final topPatterns = _aggregateTopPatterns(reviews);
    final sampleReviews = reviews.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(onPressed: onBackToProduct),
        const SizedBox(height: AppSpacing.md),
        if (isNarrow)
          _MobileHeroSection(
            detail: detail,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
          )
        else
          _DesktopHeroSection(
            detail: detail,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
          ),
        const SizedBox(height: AppSpacing.xl),
        _CategorySection(categoryDisplayName: detail.categoryDisplayName),
        const SizedBox(height: AppSpacing.xl),
        _ReviewListSection(reviews: reviews, isAnalyzing: isAnalyzing),
        if (topPatterns.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          _PatternSection(patterns: topPatterns),
        ],
        if (sampleReviews.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          _SampleReviewSection(
            reviews: sampleReviews,
            onViewAll: onBackToProduct,
          ),
        ],
      ],
    );
  }

  static List<_PatternData> _aggregateTopPatterns(List<ProductReview> reviews) {
    final counts = <String, int>{};
    for (final review in reviews) {
      for (final reason in review.reasons) {
        if (reason.isNotEmpty) {
          counts[reason] = (counts[reason] ?? 0) + 1;
        }
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted
        .take(4)
        .map((e) => _PatternData(label: e.key, count: e.value))
        .toList();
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.textSecondary,
      ),
      icon: const Icon(Icons.arrow_back_ios, size: 14),
      label: Text(
        '상품 페이지로 돌아가기',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------- Hero Section ----------

class _DesktopHeroSection extends StatelessWidget {
  const _DesktopHeroSection({
    required this.detail,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final ProductDetail detail;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: _ProductSummaryCard(detail: detail),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _RiskSummaryCard(
            rtiSummary: detail.rtiSummary,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
          ),
        ),
      ],
    );
  }
}

class _MobileHeroSection extends StatelessWidget {
  const _MobileHeroSection({
    required this.detail,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final ProductDetail detail;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProductSummaryCard(detail: detail),
        const SizedBox(height: AppSpacing.md),
        _RiskSummaryCard(
          rtiSummary: detail.rtiSummary,
          safeCount: safeCount,
          warnCount: warnCount,
          dangerCount: dangerCount,
        ),
      ],
    );
  }
}

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail.imageUrls.isNotEmpty)
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: AppNetworkImage(
                      url: detail.imageUrls.first,
                      fit: BoxFit.cover,
                      borderRadius: AppRadius.small,
                    ),
                  )
                else
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: AppRadius.small,
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.textTertiary,
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          child: Text(
                            '리뷰 위험도 리포트',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        detail.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (detail.categoryDisplayName.isNotEmpty) ...[
              Text(
                detail.categoryDisplayName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
            ],
            Text(
              '₩${_formatPrice(detail.price)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 2),
                Text(
                  detail.avgRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '리뷰 ${detail.reviewCount}개',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({
    required this.rtiSummary,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final RtiSummary rtiSummary;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    final total = safeCount + warnCount + dangerCount;
    final (riskColor, riskBg, riskLabel) = _resolveRisk(rtiSummary.rtiScore);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: riskBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                child: Text(
                  riskLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  rtiSummary.rtiScore.toString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '/ 100',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              rtiSummary.summaryMessage,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (total > 0) ...[
              _DistributionBar(
                label: '안전',
                count: safeCount,
                total: total,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSpacing.xs),
              _DistributionBar(
                label: '의심',
                count: warnCount,
                total: total,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.xs),
              _DistributionBar(
                label: '위험',
                count: dangerCount,
                total: total,
                color: AppColors.error,
              ),
            ] else ...[
              _DistributionBar(
                label: '안전',
                count: 0,
                total: 1,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSpacing.xs),
              _DistributionBar(
                label: '의심',
                count: 0,
                total: 1,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.xs),
              _DistributionBar(
                label: '위험',
                count: 0,
                total: 1,
                color: AppColors.error,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static (Color, Color, String) _resolveRisk(int score) {
    if (score >= 70) {
      return (AppColors.success, AppColors.successSoft, '신뢰할 수 있는 리뷰입니다');
    } else if (score >= 40) {
      return (AppColors.warning, AppColors.warningSoft, '주의가 필요한 상품입니다');
    } else {
      return (AppColors.error, AppColors.errorSoft, '리뷰 신뢰도가 낮은 상품입니다');
    }
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    final pctLabel = '${(pct * 100).round()}%';

    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: pct.clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 40,
          child: Text(
            pctLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        SizedBox(
          width: 28,
          child: Text(
            '($count)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Category Section ----------

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.categoryDisplayName});

  final String categoryDisplayName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Text(
              '품목 분류',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                child: Text(
                  categoryDisplayName.isNotEmpty ? categoryDisplayName : '미분류',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Review List Section ----------

class _ReviewListSection extends StatelessWidget {
  const _ReviewListSection({
    required this.reviews,
    required this.isAnalyzing,
  });

  final List<ProductReview> reviews;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '최신 리뷰 순서',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                if (isAnalyzing)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'AI 분석 중...',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (reviews.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    '분석된 리뷰가 없습니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              for (var i = 0; i < reviews.length; i++) ...[
                _ReviewRow(review: reviews[i]),
                if (i < reviews.length - 1)
                  const Divider(color: AppColors.border, height: AppSpacing.lg),
              ],
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final rtiColor = _parseColor(review.rtiColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (review.createdAt.isNotEmpty)
                    Text(
                      review.createdAt,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round()
                        ? Icons.star
                        : Icons.star_outline,
                    size: 12,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                review.content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (review.reasons.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  children: review.reasons
                      .take(3)
                      .map(
                        (r) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            child: Text(
                              r,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _RtiBadge(score: review.rtiScore, label: review.rtiLabel, color: rtiColor),
      ],
    );
  }

  static Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.textSecondary;
    }
  }
}

class _RtiBadge extends StatelessWidget {
  const _RtiBadge({
    required this.score,
    required this.label,
    required this.color,
  });

  final int score;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RTI',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
            Text(
              score.toString(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Pattern Section ----------

class _PatternData {
  const _PatternData({required this.label, required this.count});
  final String label;
  final int count;
}

class _PatternSection extends StatelessWidget {
  const _PatternSection({required this.patterns});

  final List<_PatternData> patterns;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '리뷰 이유 패턴',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '분석된 리뷰에서 반복적으로 나타나는 의심 패턴입니다.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        isNarrow
            ? Column(
                children: patterns
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _PatternCard(pattern: p),
                      ),
                    )
                    .toList(),
              )
            : _PatternGrid(patterns: patterns),
      ],
    );
  }
}

class _PatternGrid extends StatelessWidget {
  const _PatternGrid({required this.patterns});

  final List<_PatternData> patterns;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < patterns.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _PatternCard(pattern: patterns[i])),
            if (i + 1 < patterns.length) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _PatternCard(pattern: patterns[i + 1])),
            ] else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < patterns.length) {
        rows.add(const SizedBox(height: AppSpacing.sm));
      }
    }
    return Column(children: rows);
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.pattern});

  final _PatternData pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.errorSoft,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: AppColors.error,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${pattern.count}개 리뷰에서 감지됨',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Sample Review Section ----------

class _SampleReviewSection extends StatelessWidget {
  const _SampleReviewSection({
    required this.reviews,
    required this.onViewAll,
  });

  final List<ProductReview> reviews;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '대표 리뷰 샘플',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '전체 리뷰 보기',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final review in reviews) ...[
          _SampleReviewCard(review: review),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _SampleReviewCard extends StatelessWidget {
  const _SampleReviewCard({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final rtiColor = _parseColor(review.rtiColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    review.authorName.isNotEmpty
                        ? review.authorName[0].toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.authorName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (review.createdAt.isNotEmpty)
                        Text(
                          review.createdAt,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                _RtiBadge(
                  score: review.rtiScore,
                  label: review.rtiLabel,
                  color: rtiColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round()
                        ? Icons.star
                        : Icons.star_outline,
                    size: 13,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                if (review.isVerifiedPurchase) ...[
                  const SizedBox(width: AppSpacing.xs),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.successSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 1,
                      ),
                      child: Text(
                        '구매 인증',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              review.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (review.reasons.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: review.reasons
                    .map(
                      (r) => DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          child: Text(
                            r,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.textSecondary;
    }
  }
}

// ---------- Loading / Error ----------

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
