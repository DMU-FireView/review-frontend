import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/price_comparison_table.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_image_gallery.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_info_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_insight_panel.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_list_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/similar_products_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/trust_signal_card.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

enum _ProductDetailTab { review, priceComparison, spec, qa }

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  _ProductDetailTab _selectedTab = _ProductDetailTab.review;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailViewModelProvider(widget.productId));
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;

    return Scaffold(
      backgroundColor: AppColors.surface,
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
              maxWidth: 1440,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.md,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const _LoadingView(),
                ProductDetailFailure(:final failure) => _ErrorView(
                  message: failure.message,
                  onRetry: () => ref
                      .read(
                        productDetailViewModelProvider(
                          widget.productId,
                        ).notifier,
                      )
                      .refresh(),
                ),
                ProductDetailSuccess(
                  :final detail,
                  :final reviews,
                  :final reviewInsight,
                  :final similarProducts,
                  :final isAnalyzing,
                  :final safeCount,
                  :final warnCount,
                  :final dangerCount,
                ) =>
                  _DetailContent(
                    detail: detail,
                    reviews: reviews,
                    reviewInsight: reviewInsight,
                    similarProducts: similarProducts,
                    selectedTab: _selectedTab,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    onTabChanged: (tab) => setState(() => _selectedTab = tab),
                    onFeedback: (reviewId, feedbackType) => ref
                        .read(
                          productDetailViewModelProvider(
                            widget.productId,
                          ).notifier,
                        )
                        .submitFeedback(reviewId, feedbackType),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.detail,
    required this.reviews,
    required this.reviewInsight,
    required this.similarProducts,
    required this.selectedTab,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.onTabChanged,
    this.onFeedback,
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
  final _ProductDetailTab selectedTab;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final ValueChanged<_ProductDetailTab> onTabChanged;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Breadcrumb(breadcrumbs: detail.breadcrumbs),
        const SizedBox(height: AppSpacing.md),
        isMobile
            ? _MobileHeroSection(detail: detail)
            : _DesktopHeroSection(detail: detail),
        if (!isMobile && detail.specChips.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ProductSpecChipsStrip(chips: detail.specChips),
        ],
        const SizedBox(height: AppSpacing.xl),
        isMobile
            ? _MobileAnalysisSection(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => onTabChanged(_ProductDetailTab.review),
              )
            : _DesktopAnalysisSection(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => onTabChanged(_ProductDetailTab.review),
              ),
        const SizedBox(height: AppSpacing.xl),
        _ProductTabBar(
          detail: detail,
          selectedTab: selectedTab,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (selectedTab == _ProductDetailTab.review)
          isMobile
              ? _MobileReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                )
              : _DesktopReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                )
        else if (selectedTab == _ProductDetailTab.priceComparison)
          PriceComparisonTable(
            comparisons: detail.priceComparisons,
            totalSellerCount: detail.totalSellerCount,
          )
        else
          const _ComingSoonPlaceholder(),
        if (similarProducts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          SimilarProductsSection(products: similarProducts),
        ],
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.breadcrumbs});

  final List<String> breadcrumbs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < breadcrumbs.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Icon(
                Icons.chevron_right,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ),
          GestureDetector(
            onTap: i == breadcrumbs.length - 1
                ? null
                : () {
                    if (i == 0) {
                      context.goNamed(RouteNames.home);
                    } else {
                      final category = resolveProductCategory(breadcrumbs[i]);
                      context.goNamed(
                        RouteNames.search,
                        queryParameters: {
                          if (category != null) 'categoryId': category.id,
                          'category': breadcrumbs[i],
                        },
                      );
                    }
                  },
            child: Text(
              breadcrumbs[i],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: i == breadcrumbs.length - 1
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: i == breadcrumbs.length - 1
                    ? FontWeight.w700
                    : FontWeight.w500,
                decoration: i < breadcrumbs.length - 1
                    ? TextDecoration.underline
                    : null,
                decorationColor: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DesktopHeroSection extends StatelessWidget {
  const _DesktopHeroSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: ProductImageGallery(imageUrls: detail.imageUrls),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfoSection(detail: detail),
                const SizedBox(height: AppSpacing.lg),
                PriceComparisonTable(
                  comparisons: detail.priceComparisons,
                  totalSellerCount: detail.totalSellerCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHeroSection extends StatelessWidget {
  const _MobileHeroSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageGallery(imageUrls: detail.imageUrls),
        const SizedBox(height: AppSpacing.md),
        ProductInfoSection(detail: detail),
        const SizedBox(height: AppSpacing.md),
        ProductSpecChips(chips: detail.specChips),
        const SizedBox(height: AppSpacing.md),
        PriceComparisonTable(
          comparisons: detail.priceComparisons,
          totalSellerCount: detail.totalSellerCount,
        ),
      ],
    );
  }
}

class _DesktopAnalysisSection extends StatelessWidget {
  const _DesktopAnalysisSection({
    required this.detail,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAnalyzing) _AnalyzingBanner(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RtiSummaryCard(
                rtiSummary: detail.rtiSummary,
                onDetailPressed: onDetailPressed,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 280,
              child: TrustSignalCard(
                signals: detail.trustSignals,
                onDetailPressed: onDetailPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileAnalysisSection extends StatelessWidget {
  const _MobileAnalysisSection({
    required this.detail,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAnalyzing) ...[
          _AnalyzingBanner(),
          const SizedBox(height: AppSpacing.sm),
        ],
        RtiSummaryCard(
          rtiSummary: detail.rtiSummary,
          onDetailPressed: onDetailPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        TrustSignalCard(
          signals: detail.trustSignals,
          onDetailPressed: onDetailPressed,
        ),
      ],
    );
  }
}

class _AnalyzingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
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
            'AI 리뷰 분석 중...',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTabBar extends StatelessWidget {
  const _ProductTabBar({
    required this.detail,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final ProductDetail detail;
  final _ProductDetailTab selectedTab;
  final ValueChanged<_ProductDetailTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_ProductDetailTab.review, '리뷰 ${_formatTabCount(detail.reviewCount)}'),
      (_ProductDetailTab.priceComparison, '가격비교 ${detail.totalSellerCount}'),
      (_ProductDetailTab.spec, '스펙'),
      (_ProductDetailTab.qa, 'Q&A ${detail.qaCount}'),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: tabs.map((entry) {
          final (tab, label) = entry;
          final isSelected = tab == selectedTab;
          return _TabItem(
            label: label,
            isSelected: isSelected,
            onTap: () => onTabChanged(tab),
          );
        }).toList(),
      ),
    );
  }

  String _formatTabCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    }
    return count.toString();
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DesktopReviewSection extends StatelessWidget {
  const _DesktopReviewSection({
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 65,
          child: ReviewListSection(
            reviews: reviews,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
            onFeedback: onFeedback,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 280,
          child: ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        ),
      ],
    );
  }
}

class _MobileReviewSection extends StatelessWidget {
  const _MobileReviewSection({
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        const SizedBox(height: AppSpacing.md),
        ReviewListSection(
          reviews: reviews,
          safeCount: safeCount,
          warnCount: warnCount,
          dangerCount: dangerCount,
          onFeedback: onFeedback,
        ),
      ],
    );
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          '준비 중입니다.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

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
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
