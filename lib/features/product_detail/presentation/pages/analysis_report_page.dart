import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
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
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const _SkeletonView(),
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
                  :final trend,
                ) =>
                  _ReportContent(
                    productId: productId,
                    detail: detail,
                    reviews: reviews,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    trend: trend,
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

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton Loading
// ─────────────────────────────────────────────────────────────────────────────

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 160, height: 16, radius: 8),
          const SizedBox(height: AppSpacing.md),
          isNarrow
              ? Column(
                  children: [
                    _ShimmerBox(height: 200, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    _ShimmerBox(height: 240, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    _ShimmerBox(height: 120, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    _ShimmerBox(height: 120, radius: AppRadius.md),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 58,
                      child: Column(
                        children: [
                          _ShimmerBox(height: 240, radius: AppRadius.md),
                          const SizedBox(height: AppSpacing.lg),
                          _ShimmerBox(height: 280, radius: AppRadius.md),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          _ShimmerBox(height: 280, radius: AppRadius.md),
                          const SizedBox(height: AppSpacing.md),
                          _ShimmerBox(height: 140, radius: AppRadius.md),
                          const SizedBox(height: AppSpacing.md),
                          _ShimmerBox(height: 140, radius: AppRadius.md),
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

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, required this.height, this.radius = 0});
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Report Content
// ─────────────────────────────────────────────────────────────────────────────

class _ReportContent extends StatelessWidget {
  const _ReportContent({
    required this.productId,
    required this.detail,
    required this.reviews,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.trend,
    required this.onBackToProduct,
  });

  final int productId;
  final ProductDetail detail;
  final List<ProductReview> reviews;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<AnalysisTrendPoint> trend;
  final VoidCallback onBackToProduct;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    final topPatterns = _aggregateTopPatterns(reviews);

    // Derive distribution from reviews' rtiScore when analysis counts not yet available
    final int effSafe, effWarn, effDanger;
    if (safeCount + warnCount + dangerCount == 0 && reviews.isNotEmpty) {
      int s = 0, w = 0, d = 0;
      for (final r in reviews) {
        if (r.rtiScore <= 0) continue;
        if (r.rtiScore >= 70) {
          s++;
        } else if (r.rtiScore >= 40) {
          w++;
        } else {
          d++;
        }
      }
      effSafe = s;
      effWarn = w;
      effDanger = d;
    } else {
      effSafe = safeCount;
      effWarn = warnCount;
      effDanger = dangerCount;
    }

    final rightColumn = Column(
      children: [
        _TrustStatusCard(
          detail: detail,
          rtiSummary: detail.rtiSummary,
          safeCount: effSafe,
          warnCount: effWarn,
          dangerCount: effDanger,
          isAnalyzing: isAnalyzing,
        ),
        const SizedBox(height: AppSpacing.md),
        _AnalysisSummaryCard(
          rtiSummary: detail.rtiSummary,
          reviews: reviews,
          safeCount: effSafe,
          warnCount: effWarn,
          dangerCount: effDanger,
        ),
        const SizedBox(height: AppSpacing.md),
        _RecommendedActionsCard(onGoToReviews: onBackToProduct),
      ],
    );

    final leftColumn = Column(
      children: [
        _ProductHeroCard(
          detail: detail,
          isAnalyzing: isAnalyzing,
          onBack: onBackToProduct,
        ),
        const SizedBox(height: AppSpacing.lg),
        _TrendSection(trend: trend, isAnalyzing: isAnalyzing),
        if (topPatterns.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _PatternSection(patterns: topPatterns),
        ],
        const SizedBox(height: AppSpacing.lg),
        _ReviewListSection(reviews: reviews, isAnalyzing: isAnalyzing),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(onPressed: onBackToProduct),
        const SizedBox(height: AppSpacing.md),
        if (isNarrow)
          Column(
            children: [
              _ProductHeroCard(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onBack: onBackToProduct,
              ),
              const SizedBox(height: AppSpacing.md),
              _TrustStatusCard(
                detail: detail,
                rtiSummary: detail.rtiSummary,
                safeCount: effSafe,
                warnCount: effWarn,
                dangerCount: effDanger,
                isAnalyzing: isAnalyzing,
              ),
              const SizedBox(height: AppSpacing.md),
              _AnalysisSummaryCard(
                rtiSummary: detail.rtiSummary,
                reviews: reviews,
                safeCount: effSafe,
                warnCount: effWarn,
                dangerCount: effDanger,
              ),
              const SizedBox(height: AppSpacing.md),
              _TrendSection(trend: trend, isAnalyzing: isAnalyzing),
              const SizedBox(height: AppSpacing.md),
              _RecommendedActionsCard(onGoToReviews: onBackToProduct),
              if (topPatterns.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _PatternSection(patterns: topPatterns),
              ],
              const SizedBox(height: AppSpacing.lg),
              _ReviewListSection(reviews: reviews, isAnalyzing: isAnalyzing),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 58, child: leftColumn),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(width: 320, child: rightColumn),
            ],
          ),
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
      icon: const Icon(Icons.arrow_back_ios, size: 13),
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

// ─────────────────────────────────────────────────────────────────────────────
// Product Hero Card (Left)
// ─────────────────────────────────────────────────────────────────────────────

class _ProductHeroCard extends StatelessWidget {
  const _ProductHeroCard({
    required this.detail,
    required this.isAnalyzing,
    required this.onBack,
  });

  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final (riskColor, _, riskLabel) = _resolveRisk(detail.rtiSummary.rtiScore);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badge row
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 11,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '상품 단위 리포트',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Product info row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with RTI badge overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: detail.imageUrls.isNotEmpty
                          ? SizedBox(
                              width: 88,
                              height: 88,
                              child: AppNetworkImage(
                                url: detail.imageUrls.first,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 88,
                              height: 88,
                              color: AppColors.surfaceMuted,
                              child: const Icon(
                                Icons.image_outlined,
                                color: AppColors.textTertiary,
                              ),
                            ),
                    ),
                    // RTI circle badge (bottom-left)
                    Positioned(
                      bottom: -8,
                      left: -8,
                      child: _RtiCircle(
                        score: detail.rtiSummary.rtiScore,
                        color: riskColor,
                        label: riskLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Meta row
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          if (detail.sellerName != null &&
                              detail.sellerName!.isNotEmpty)
                            _MetaChip(label: detail.sellerName!),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                detail.avgRating.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            '리뷰 ${detail.reviewCount}개',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 11,
                                ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: isAnalyzing
                                  ? AppColors.primaryLight
                                  : AppColors.successSoft,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isAnalyzing)
                                    const SizedBox(
                                      width: 8,
                                      height: 8,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.check_circle,
                                      size: 9,
                                      color: AppColors.success,
                                    ),
                                  const SizedBox(width: 3),
                                  Text(
                                    isAnalyzing ? '분석 중' : '분석 완료',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isAnalyzing
                                              ? AppColors.primary
                                              : AppColors.success,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 9,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSpacing.md),
            // Price
            Text(
              '₩${_formatPrice(detail.price)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onBack,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.medium,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios, size: 13),
                    label: const Text(
                      '상품 상세로 돌아가기',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static (Color, Color, String) _resolveRisk(int score) {
    if (score >= 70) {
      return (AppColors.success, AppColors.successSoft, '신뢰');
    } else if (score >= 40) {
      return (AppColors.warning, AppColors.warningSoft, '의심');
    } else {
      return (AppColors.error, AppColors.errorSoft, '위험');
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _RtiCircle extends StatelessWidget {
  const _RtiCircle({
    required this.score,
    required this.color,
    required this.label,
  });

  final int score;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: color.withValues(alpha: 0.85),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trust Status Card (Right)
// ─────────────────────────────────────────────────────────────────────────────

class _TrustStatusCard extends StatelessWidget {
  const _TrustStatusCard({
    required this.detail,
    required this.rtiSummary,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.isAnalyzing,
  });

  final ProductDetail detail;
  final RtiSummary rtiSummary;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    final total = safeCount + warnCount + dangerCount;
    final (riskColor, riskBg, riskLabel, riskTitle) =
        _resolveRisk(rtiSummary.rtiScore);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '전체 리뷰 신뢰 상태',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: riskColor.withValues(alpha: 0.35),
                    ),
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
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              riskTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Score + description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular score
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: riskBg,
                    border: Border.all(color: riskColor, width: 2.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rtiSummary.rtiScore.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: riskColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        'RTI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: riskColor.withValues(alpha: 0.75),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _buildDescription(rtiSummary, detail.trustSignals),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Distribution bars
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                _DistRow(
                  label: '신뢰',
                  count: safeCount,
                  total: total,
                  color: AppColors.success,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
                const SizedBox(height: 10),
                _DistRow(
                  label: '의심',
                  count: warnCount,
                  total: total,
                  color: AppColors.warning,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
                const SizedBox(height: 10),
                _DistRow(
                  label: '위험',
                  count: dangerCount,
                  total: total,
                  color: AppColors.error,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _buildDescription(
    RtiSummary rtiSummary,
    List<TrustSignal> signals,
  ) {
    if (signals.isNotEmpty) {
      final negSignals = signals.where((s) => !s.isPositive).toList();
      if (negSignals.isNotEmpty) {
        return '${negSignals.map((s) => s.label).take(2).join('과 ')} 등 의심 신호가 감지되었어요. 구매 전 신뢰 리뷰를 꼼꼼히 확인하는 것을 권장합니다.';
      }
    }
    return '${rtiSummary.analyzedReviewCount}개 리뷰를 AI가 분석했습니다. 신뢰도 점수와 분포를 참고하여 구매를 결정하세요.';
  }

  static (Color, Color, String, String) _resolveRisk(int score) {
    if (score >= 70) {
      return (
        AppColors.success,
        AppColors.successSoft,
        '신뢰 구간',
        '신뢰할 수 있는 상품입니다',
      );
    } else if (score >= 40) {
      return (
        AppColors.warning,
        AppColors.warningSoft,
        '의심 구간',
        '주의가 필요한 상품입니다',
      );
    } else {
      return (
        AppColors.error,
        AppColors.errorSoft,
        '위험 구간',
        '리뷰 신뢰도가 낮은 상품입니다',
      );
    }
  }
}

class _DistRow extends StatelessWidget {
  const _DistRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    required this.isAnalyzing,
  });

  final String label;
  final int count;
  final int total;
  final Color color;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    final pctText = '${(pct * 100).round()}%';

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: isAnalyzing
              ? Shimmer.fromColors(
                  baseColor: const Color(0xFFE5E7EB),
                  highlightColor: const Color(0xFFF9FAFB),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: pct,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.12),
                    minHeight: 8,
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 34,
          child: Text(
            pctText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Analysis Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _AnalysisSummaryCard extends StatelessWidget {
  const _AnalysisSummaryCard({
    required this.rtiSummary,
    required this.reviews,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final RtiSummary rtiSummary;
  final List<ProductReview> reviews;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    // Find top reason pattern
    final reasonCounts = <String, int>{};
    for (final r in reviews) {
      for (final s in r.reasons) {
        if (s.isNotEmpty) reasonCounts[s] = (reasonCounts[s] ?? 0) + 1;
      }
    }
    final topReason = reasonCounts.isEmpty
        ? '-'
        : (reasonCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '분석 요약',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: '분석 리뷰',
              value: '${rtiSummary.analyzedReviewCount}개',
            ),
            _SummaryRow(
              label: '평균 RTI',
              value: '${rtiSummary.rtiScore}점',
            ),
            _SummaryRow(
              label: '위험 리뷰',
              value: '$dangerCount개',
              valueColor: AppColors.error,
            ),
            _SummaryRow(
              label: '신뢰 리뷰',
              value: '$safeCount개',
              valueColor: AppColors.success,
            ),
            _SummaryRow(
              label: '주요 신호',
              value: topReason.length > 12
                  ? '${topReason.substring(0, 12)}…'
                  : topReason,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recommended Actions Card
// ─────────────────────────────────────────────────────────────────────────────

class _RecommendedActionsCard extends StatelessWidget {
  const _RecommendedActionsCard({required this.onGoToReviews});
  final VoidCallback onGoToReviews;

  @override
  Widget build(BuildContext context) {
    final items = [
      '신뢰 리뷰 먼저 보기',
      '위험 리뷰 근거 확인',
      '비슷한 상품과 비교',
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '추천 확인 순서',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    GestureDetector(
                      onTap: onGoToReviews,
                      child: Text(
                        items[i],
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.border,
                        ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Trend Section
// ─────────────────────────────────────────────────────────────────────────────

class _TrendSection extends StatefulWidget {
  const _TrendSection({required this.trend, required this.isAnalyzing});
  final List<AnalysisTrendPoint> trend;
  final bool isAnalyzing;

  @override
  State<_TrendSection> createState() => _TrendSectionState();
}

class _TrendSectionState extends State<_TrendSection> {
  int _selectedDays = 30;

  List<AnalysisTrendPoint> get _filtered {
    if (widget.trend.isEmpty) return [];
    final cutoff = DateTime.now().subtract(Duration(days: _selectedDays));
    final filtered = widget.trend.where((p) {
      try {
        return DateTime.parse(p.date).isAfter(cutoff);
      } catch (_) {
        return true;
      }
    }).toList();
    return filtered.isEmpty ? widget.trend : filtered;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
                        '위험도 추이',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '상품 리뷰의 평균 RTI와 위험 리뷰 비율 변화를 보여줘요.',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Period tabs
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [7, 30, 90].map((d) {
                        final selected = _selectedDays == d;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDays = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.surface
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xs),
                              boxShadow: selected
                                  ? [
                                      const BoxShadow(
                                        color: AppColors.shadow,
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              '$d일',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: selected
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary,
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Chart area
            if (widget.isAnalyzing && widget.trend.isEmpty)
              Shimmer.fromColors(
                baseColor: const Color(0xFFE5E7EB),
                highlightColor: const Color(0xFFF9FAFB),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              )
            else if (widget.trend.isEmpty)
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 36,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'AI 분석 완료 후 위험도 추이를 확인할 수 있습니다',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: _TrendChart(points: _filtered),
              ),
            if (widget.trend.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _LegendDot(color: AppColors.primary, label: '평균 RTI'),
                  const SizedBox(width: AppSpacing.md),
                  _LegendDash(
                    color: const Color(0xFFF97316),
                    label: '위험 리뷰 비율',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 3,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _LegendDash extends StatelessWidget {
  const _LegendDash({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
              width: 6,
              height: 2,
              margin: const EdgeInsets.only(right: 2),
              color: color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// Chart Widget
class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.points});
  final List<AnalysisTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      painter: _TrendChartPainter(points: points),
      size: Size.infinite,
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  const _TrendChartPainter({required this.points});
  final List<AnalysisTrendPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    const leftPad = 36.0;
    const bottomPad = 24.0;
    const topPad = 8.0;

    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final chartLeft = leftPad;
    final chartTop = topPad;
    final chartBottom = size.height - bottomPad;

    // Grid lines (0, 25, 50, 75, 100)
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(
      color: Color(0xFF9CA3AF),
      fontSize: 10,
    );

    for (var i = 0; i <= 4; i++) {
      final y = chartTop + chartH * (1 - i / 4);
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartW, y),
        gridPaint,
      );
      final label = '${(i * 25).toInt()}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Compute point positions
    Offset pt(int i, double value) {
      final x = chartLeft + chartW * i / (points.length - 1);
      final y = chartTop + chartH * (1 - value.clamp(0, 100) / 100);
      return Offset(x, y);
    }

    final rtiPts = List.generate(
      points.length,
      (i) => pt(i, points[i].averageRti),
    );
    final dangerPts = List.generate(points.length, (i) {
      final rc = points[i].reviewCount;
      final pct = rc > 0 ? points[i].dangerCount / rc * 100 : 0.0;
      return pt(i, pct);
    });

    // Draw RTI filled area
    final fillPath = Path()
      ..moveTo(rtiPts.first.dx, chartBottom);
    for (final pt in rtiPts) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(rtiPts.last.dx, chartBottom);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFF2563EB).withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Draw RTI smooth line
    _drawSmoothLine(
      canvas,
      rtiPts,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw danger% dashed line
    _drawDashedLine(
      canvas,
      dangerPts,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // X-axis date labels
    final labelCount = math.min(5, points.length);
    final step = (points.length / labelCount).ceil().clamp(1, 999);
    for (var i = 0; i < points.length; i += step) {
      final x = chartLeft + chartW * i / (points.length - 1);
      final dateLabel = _fmtDate(points[i].date);
      final tp = TextPainter(
        text: TextSpan(text: dateLabel, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - bottomPad + 6));
    }
    // Always show last
    {
      final tp = TextPainter(
        text: TextSpan(text: '오늘', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          chartLeft + chartW - tp.width,
          size.height - bottomPad + 6,
        ),
      );
    }
  }

  static void _drawSmoothLine(
    Canvas canvas,
    List<Offset> pts,
    Paint paint,
  ) {
    if (pts.length < 2) return;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final cp1x = pts[i].dx +
          (pts[i + 1].dx - (i > 0 ? pts[i - 1].dx : pts[0].dx)) / 6;
      final cp1y = pts[i].dy +
          (pts[i + 1].dy - (i > 0 ? pts[i - 1].dy : pts[0].dy)) / 6;
      final cp2x = pts[i + 1].dx -
          (i + 2 < pts.length
                  ? pts[i + 2].dx - pts[i].dx
                  : pts[i + 1].dx - pts[i].dx) /
              6;
      final cp2y = pts[i + 1].dy -
          (i + 2 < pts.length
                  ? pts[i + 2].dy - pts[i].dy
                  : pts[i + 1].dy - pts[i].dy) /
              6;
      path.cubicTo(cp1x, cp1y, cp2x, cp2y, pts[i + 1].dx, pts[i + 1].dy);
    }
    canvas.drawPath(path, paint);
  }

  static void _drawDashedLine(
    Canvas canvas,
    List<Offset> pts,
    Paint paint,
  ) {
    const dashLen = 6.0;
    const gapLen = 4.0;
    for (var i = 0; i < pts.length - 1; i++) {
      final dx = pts[i + 1].dx - pts[i].dx;
      final dy = pts[i + 1].dy - pts[i].dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist == 0) continue;
      final ux = dx / dist;
      final uy = dy / dist;
      var remaining = dist;
      var x = pts[i].dx;
      var y = pts[i].dy;
      var drawing = true;
      while (remaining > 0) {
        final len = math.min(drawing ? dashLen : gapLen, remaining);
        if (drawing) {
          canvas.drawLine(
            Offset(x, y),
            Offset(x + ux * len, y + uy * len),
            paint,
          );
        }
        x += ux * len;
        y += uy * len;
        remaining -= len;
        drawing = !drawing;
      }
    }
  }

  static String _fmtDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return raw.length > 5 ? raw.substring(5) : raw;
    }
  }

  @override
  bool shouldRepaint(_TrendChartPainter old) => old.points != points;
}

// ─────────────────────────────────────────────────────────────────────────────
// Pattern Section
// ─────────────────────────────────────────────────────────────────────────────

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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.errorSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '리뷰 이유 패턴',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '반복적으로 나타나는 의심 패턴입니다.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            isNarrow
                ? Column(
                    children: patterns
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: _PatternTile(pattern: p),
                          ),
                        )
                        .toList(),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < patterns.length; i += 2) ...[
                        Row(
                          children: [
                            Expanded(child: _PatternTile(pattern: patterns[i])),
                            if (i + 1 < patterns.length) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: _PatternTile(pattern: patterns[i + 1]),
                              ),
                            ] else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                        if (i + 2 < patterns.length)
                          const SizedBox(height: AppSpacing.xs),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _PatternTile extends StatelessWidget {
  const _PatternTile({required this.pattern});
  final _PatternData pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            const Icon(Icons.error_outline, size: 16, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${pattern.count}개 리뷰에서 감지',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.error.withValues(alpha: 0.65),
                      fontSize: 10,
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

// ─────────────────────────────────────────────────────────────────────────────
// Review List Section
// ─────────────────────────────────────────────────────────────────────────────

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
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
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
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'AI 분석 중',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (reviews.isEmpty)
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.xl),
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
                  const Divider(
                    color: AppColors.border,
                    height: AppSpacing.lg,
                  ),
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
                  if (review.createdAt.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      review.createdAt,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round()
                        ? Icons.star
                        : Icons.star_outline,
                    size: 11,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (review.reasons.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  children: review.reasons
                      .take(2)
                      .map(
                        (r) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            child: Text(
                              r,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
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
        _RtiBadge(
          score: review.rtiScore,
          label: review.rtiLabel,
          color: rtiColor,
        ),
      ],
    );
  }

  static Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
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
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RTI',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.7),
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
          if (label.isNotEmpty)
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error / Loading
// ─────────────────────────────────────────────────────────────────────────────

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
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textTertiary,
            ),
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
