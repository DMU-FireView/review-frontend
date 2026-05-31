import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_filter_bar.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_product_card.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_summary_card.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/core/providers/core_providers.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  WishlistFilterOption _selectedFilter = WishlistFilterOption.all;
  WishlistSortOption _sortOption = WishlistSortOption.recent;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wishlistViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final dashboardState = ref.watch(homeDashboardViewModelProvider);

    final keywords = _keywordsFrom(dashboardState);
    final products = _productsFrom(dashboardState);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () {},
              onCartPressed: () => context.go(RoutePaths.login),
              onNavItemPressed: (_) => context.go(RoutePaths.home),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              searchKeywords: keywords,
              searchRecommendedProducts: products,
              onMyPagePressed: () => context.go(RoutePaths.login),
              onProfileWishPressed: () {},
              onProfileOrderPressed: () => context.go(RoutePaths.login),
              onLogoutPressed: () {
                ref.read(authTokenStoreProvider.notifier).clear();
                context.go(RoutePaths.landing);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1760,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.lg,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (wishlistState) {
                WishlistLoading() || WishlistInitial() => const SizedBox(
                  height: 320,
                  child: AppLoadingView(message: '찜 목록을 불러오는 중입니다.'),
                ),
                WishlistFailure(:final failure) => SizedBox(
                  height: 320,
                  child: AppErrorView(
                    message: failure.message,
                    onRetry: () =>
                        ref.read(wishlistViewModelProvider.notifier).load(),
                  ),
                ),
                WishlistEmpty() => _WishlistEmptyBody(
                  onGoHome: () => context.go(RoutePaths.home),
                ),
                WishlistSuccess(
                  :final items,
                  :final summary,
                  :final togglingProductIds,
                ) =>
                  _WishlistBody(
                    items: items,
                    summary: summary,
                    togglingProductIds: togglingProductIds,
                    selectedFilter: _selectedFilter,
                    sortOption: _sortOption,
                    onFilterSelected: (f) =>
                        setState(() => _selectedFilter = f),
                    onSortChanged: (s) => setState(() => _sortOption = s),
                    onRemove: (productId) => ref
                        .read(wishlistViewModelProvider.notifier)
                        .removeItem(productId),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _keywordsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.trendingKeywords.map((k) => k.keyword).toList(),
      _ => const [],
    };
  }

  List<HomeProductData> _productsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.recommendedProducts
            .map(
              (p) => HomeProductData(
                productId: p.id,
                name: p.name,
                storeName: p.storeName,
                priceLabel: '${p.price}원',
                ratingLabel: p.rating?.toStringAsFixed(1) ?? '-',
                reviewCountLabel: p.reviewCount?.toString() ?? '-',
                rtiLabel: p.rtiScore == null ? '' : 'RTI ${p.rtiScore}',
                imageUrl: p.imageUrl,
                label: p.label ?? '',
              ),
            )
            .toList(),
      _ => const [],
    };
  }
}

class _WishlistBody extends StatelessWidget {
  const _WishlistBody({
    required this.items,
    required this.summary,
    required this.togglingProductIds,
    required this.selectedFilter,
    required this.sortOption,
    required this.onFilterSelected,
    required this.onSortChanged,
    required this.onRemove,
  });

  final List<WishlistItem> items;
  final WishlistSummary summary;
  final Set<int> togglingProductIds;
  final WishlistFilterOption selectedFilter;
  final WishlistSortOption sortOption;
  final ValueChanged<WishlistFilterOption> onFilterSelected;
  final ValueChanged<WishlistSortOption> onSortChanged;
  final ValueChanged<int> onRemove;

  List<WishlistItem> get _filtered {
    var result = switch (selectedFilter) {
      WishlistFilterOption.all => [...items],
      WishlistFilterOption.priceDrop =>
        items.where((i) => i.isPriceDrop).toList(),
      WishlistFilterOption.rti => [
        ...items,
      ]..sort((a, b) => b.avgRti.compareTo(a.avgRti)),
      WishlistFilterOption.lowestPrice => [
        ...items,
      ]..sort((a, b) => a.price.compareTo(b.price)),
      WishlistFilterOption.brand => [...items],
      WishlistFilterOption.category => [...items],
    };

    switch (sortOption) {
      case WishlistSortOption.recent:
        result.sort(
          (a, b) =>
              (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)),
        );
      case WishlistSortOption.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
      case WishlistSortOption.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
      case WishlistSortOption.rti:
        result.sort((a, b) => b.avgRti.compareTo(a.avgRti));
      case WishlistSortOption.reviewCount:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _filtered;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WishlistPageHeader(totalCount: items.length),
        const SizedBox(height: AppSpacing.md),
        if (!isMobile)
          WishlistSummaryCard(summary: summary, totalCount: items.length),
        if (!isMobile) const SizedBox(height: AppSpacing.md),
        WishlistFilterBar(
          items: items,
          selectedFilter: selectedFilter,
          sortOption: sortOption,
          onFilterSelected: onFilterSelected,
          onSortChanged: onSortChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          WishlistSummaryCard(summary: summary, totalCount: items.length),
        if (isMobile) const SizedBox(height: AppSpacing.md),
        if (displayItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
            child: Center(
              child: Text(
                '선택한 필터에 해당하는 찜 상품이 없습니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          _WishlistGrid(
            items: displayItems,
            togglingProductIds: togglingProductIds,
            onRemove: onRemove,
          ),
      ],
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  const _WishlistGrid({
    required this.items,
    required this.togglingProductIds,
    required this.onRemove,
  });

  final List<WishlistItem> items;
  final Set<int> togglingProductIds;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      >= 1400 => 6,
      >= 1100 => 5,
      >= 860 => 4,
      >= 600 => 3,
      >= 400 => 2,
      _ => 2,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return WishlistProductCard(
          item: item,
          isToggling: togglingProductIds.contains(item.productId),
          onRemove: () => onRemove(item.productId),
        );
      },
    );
  }
}

class _WishlistPageHeader extends StatelessWidget {
  const _WishlistPageHeader({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '찜한 상품',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '저장된 상품을 한눈에 보고 가격과 리뷰 신뢰도를 확인해보세요.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(Icons.favorite, size: 14, color: AppColors.error),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '찜한 상품 $totalCount개',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WishlistEmptyBody extends StatelessWidget {
  const _WishlistEmptyBody({required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '찜한 상품이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '상품 카드의 하트를 눌러 찜 목록에 추가해보세요.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(onPressed: onGoHome, child: const Text('상품 탐색하러 가기')),
        ],
      ),
    );
  }
}
