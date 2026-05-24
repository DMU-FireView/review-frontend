import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
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
import 'package:re_view_front/features/search/presentation/widgets/search_header.dart';
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
    final state = ref.watch(
      productDetailViewModelProvider(widget.productId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SearchHeader(
              query: '',
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
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
                        productDetailViewModelProvider(widget.productId)
                            .notifier,
                      )
                      .refresh(),
                ),
                ProductDetailSuccess(
                  :final detail,
                  :final reviews,
                  :final reviewInsight,
                  :final similarProducts,
                ) => _DetailContent(
                  detail: detail,
                  reviews: reviews,
                  reviewInsight: reviewInsight,
                  similarProducts: similarProducts,
                  selectedTab: _selectedTab,
                  onTabChanged: (tab) => setState(() => _selectedTab = tab),
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
    required this.onTabChanged,
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
  final _ProductDetailTab selectedTab;
  final ValueChanged<_ProductDetailTab> onTabChanged;

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
        const SizedBox(height: AppSpacing.xl),
        isMobile
            ? _MobileAnalysisSection(detail: detail)
            : _DesktopAnalysisSection(detail: detail),
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
                )
              : _DesktopReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
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
          Text(
            breadcrumbs[i],
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: i == breadcrumbs.length - 1
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: i == breadcrumbs.length - 1
                  ? FontWeight.w700
                  : FontWeight.w500,
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
          SizedBox(
            width: 420,
            child: ProductImageGallery(imageUrls: detail.imageUrls),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfoSection(detail: detail),
                const SizedBox(height: AppSpacing.lg),
                PriceComparisonTable(
                  comparisons: detail.priceComparisons,
                  totalSellerCount: detail.totalSellerCount,
                ),
                const SizedBox(height: AppSpacing.lg),
                ProductSpecChips(chips: detail.specChips),
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
  const _DesktopAnalysisSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RtiSummaryCard(
            rtiSummary: detail.rtiSummary,
            onDetailPressed: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 280,
          child: TrustSignalCard(
            signals: detail.trustSignals,
            onDetailPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _MobileAnalysisSection extends StatelessWidget {
  const _MobileAnalysisSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RtiSummaryCard(
          rtiSummary: detail.rtiSummary,
          onDetailPressed: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        TrustSignalCard(
          signals: detail.trustSignals,
          onDetailPressed: () {},
        ),
      ],
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
      (
        _ProductDetailTab.review,
        '리뷰 ${_formatTabCount(detail.reviewCount)}',
      ),
      (
        _ProductDetailTab.priceComparison,
        '가격비교 ${detail.totalSellerCount}',
      ),
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
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 65,
          child: ReviewListSection(reviews: reviews),
        ),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 280,
          child: ReviewInsightPanel(
            insight: insight,
            onMorePressed: () {},
          ),
        ),
      ],
    );
  }
}

class _MobileReviewSection extends StatelessWidget {
  const _MobileReviewSection({
    required this.reviews,
    required this.insight,
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        const SizedBox(height: AppSpacing.md),
        ReviewListSection(reviews: reviews),
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
