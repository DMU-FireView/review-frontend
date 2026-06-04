import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  final _topKey = GlobalKey();
  final _savedKey = GlobalKey();
  final _recentKey = GlobalKey();
  final _settingsKey = GlobalKey();
  final _accountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wishlistViewModelProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    final myPageState = ref.watch(myPageViewModelProvider);
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final cartCount = ref.watch(cartItemCountProvider).value ?? 0;
    final wishlistCount = ref.watch(wishlistItemCountProvider).value ?? 0;

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
              cartCount: cartCount,
              wishlistCount: wishlistCount,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onNavItemPressed: (_) => context.go(RoutePaths.home),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: _handleSearchSubmitted,
              searchKeywords: _keywordsFrom(dashboardState),
              searchRecommendedProducts: _productsFrom(dashboardState),
              onSearchSuggestionsRequested: _handleSearchSuggestionsRequested,
              onMyPagePressed: () {},
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: _handleLogout,
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1320,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (myPageState) {
                MyPageLoading() => const SizedBox(
                  height: 360,
                  child: AppLoadingView(message: '마이페이지 정보를 불러오는 중입니다.'),
                ),
                MyPageFailure(:final failure) => SizedBox(
                  height: 360,
                  child: AppErrorView(
                    message: failure.message,
                    onRetry: () =>
                        ref.read(myPageViewModelProvider.notifier).load(),
                  ),
                ),
                MyPageSuccess(:final profile) => _MyPageBody(
                  profile: profile,
                  dashboardState: dashboardState,
                  wishlistState: wishlistState,
                  wishlistCount: wishlistCount,
                  onProductTap: _goProductDetail,
                  onWishlistTap: () => context.go(RoutePaths.wishlist),
                  onCartTap: () => context.go(RoutePaths.cart),
                  onPasswordTap: () => context.go(RoutePaths.passwordReset),
                  onTopTap: () => _scrollTo(_topKey),
                  onRecentTap: () => _scrollTo(_recentKey),
                  onReviewTap: () => _scrollTo(_recentKey),
                  onSettingsTap: () => _scrollTo(_settingsKey),
                  onAccountTap: () => _scrollTo(_accountKey),
                  topKey: _topKey,
                  savedKey: _savedKey,
                  recentKey: _recentKey,
                  settingsKey: _settingsKey,
                  accountKey: _accountKey,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _handleSearchSuggestionsRequested(String query) {
    return ref
        .read(searchAutocompleteRemoteDataSourceProvider)
        .fetchSuggestions(query);
  }

  void _handleSearchSubmitted(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.goNamed(RouteNames.search, queryParameters: {'q': query});
  }

  void _goProductDetail(String productId) {
    context.goNamed(
      RouteNames.productDetail,
      pathParameters: {'id': productId},
    );
  }

  void _handleLogout() {
    ref.read(authTokenStoreProvider.notifier).clear();
    context.go(RoutePaths.landing);
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
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
            .map(_toHomeProductData)
            .toList(growable: false),
      _ => const [],
    };
  }

  HomeProductData _toHomeProductData(DashboardProduct product) {
    return HomeProductData(
      productId: product.id,
      name: product.name,
      storeName: product.storeName,
      priceLabel: _formatPrice(product.price),
      ratingLabel: product.rating?.toStringAsFixed(1) ?? '-',
      reviewCountLabel: product.reviewCount?.toString() ?? '-',
      rtiLabel: product.rtiScore == null ? '' : 'RTI ${product.rtiScore}',
      imageUrl: product.imageUrl,
      label: product.label ?? '',
    );
  }
}

class _MyPageBody extends StatelessWidget {
  const _MyPageBody({
    required this.profile,
    required this.dashboardState,
    required this.wishlistState,
    required this.wishlistCount,
    required this.onProductTap,
    required this.onWishlistTap,
    required this.onCartTap,
    required this.onPasswordTap,
    required this.onTopTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onSettingsTap,
    required this.onAccountTap,
    required this.topKey,
    required this.savedKey,
    required this.recentKey,
    required this.settingsKey,
    required this.accountKey,
  });

  final UserProfile profile;
  final HomeDashboardState dashboardState;
  final WishlistState wishlistState;
  final int wishlistCount;
  final ValueChanged<String> onProductTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;
  final VoidCallback onPasswordTap;
  final VoidCallback onTopTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onAccountTap;
  final GlobalKey topKey;
  final GlobalKey savedKey;
  final GlobalKey recentKey;
  final GlobalKey settingsKey;
  final GlobalKey accountKey;

  @override
  Widget build(BuildContext context) {
    final savedItems = _wishlistItems;
    final recentProducts = _recentProducts;
    final riskyProducts = _riskyProducts;
    final savedAverageRti = _savedAverageRti;
    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatGrid(
          wishlistCount: wishlistCount,
          recentCount: recentProducts.length,
          riskyCount: riskyProducts.length,
          notificationCount: _notificationCount,
          onWishlistTap: onWishlistTap,
          onRecentTap: onRecentTap,
          onReviewTap: onReviewTap,
          onNotificationTap: onSettingsTap,
        ),
        const SizedBox(height: AppSpacing.xl),
        KeyedSubtree(
          key: savedKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionHeader(title: '관심 상품', onMore: onWishlistTap),
              const SizedBox(height: AppSpacing.md),
              _SavedProductsSection(
                items: savedItems,
                isLoading:
                    wishlistState is WishlistLoading ||
                    wishlistState is WishlistInitial,
                onProductTap: (id) => onProductTap(id.toString()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _ResponsiveTwoColumn(
          left: KeyedSubtree(
            key: recentKey,
            child: _RecentActivitySection(
              savedItems: savedItems,
              recentProducts: recentProducts,
              onProductTap: onProductTap,
            ),
          ),
          right: KeyedSubtree(
            key: settingsKey,
            child: _TrustSummaryPanel(
              savedAverageRti: savedAverageRti,
              riskyCount: riskyProducts.length,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        KeyedSubtree(
          key: accountKey,
          child: _AccountSection(
            profile: profile,
            onPasswordTap: onPasswordTap,
            onSettingsTap: onSettingsTap,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyedSubtree(
          key: topKey,
          child: _PageTitle(profile: profile),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (context.viewportSize.width < 980) ...[
          _SideNavCard(
            profile: profile,
            onTopTap: onTopTap,
            onCartTap: onCartTap,
            onWishlistTap: onWishlistTap,
            onRecentTap: onRecentTap,
            onReviewTap: onReviewTap,
            onSettingsTap: onSettingsTap,
          ),
          const SizedBox(height: AppSpacing.xl),
          mainContent,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: _SideNavCard(
                  profile: profile,
                  onTopTap: onTopTap,
                  onCartTap: onCartTap,
                  onWishlistTap: onWishlistTap,
                  onRecentTap: onRecentTap,
                  onReviewTap: onReviewTap,
                  onSettingsTap: onSettingsTap,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: mainContent),
            ],
          ),
      ],
    );
  }

  List<WishlistItem> get _wishlistItems {
    return switch (wishlistState) {
      WishlistSuccess(:final items) => items,
      _ => const [],
    };
  }

  List<DashboardProduct> get _recentProducts {
    return switch (dashboardState) {
      HomeDashboardSuccess(:final dashboard) => dashboard.recentProducts,
      _ => const [],
    };
  }

  List<DashboardProduct> get _riskyProducts {
    return switch (dashboardState) {
      HomeDashboardSuccess(:final dashboard) => dashboard.riskyProducts,
      _ => const [],
    };
  }

  double? get _savedAverageRti {
    final scoredItems = _wishlistItems.where((item) => item.avgRti > 0);
    if (scoredItems.isEmpty) return null;

    final total = scoredItems.fold<double>(0, (sum, item) => sum + item.avgRti);
    return total / scoredItems.length;
  }

  int get _notificationCount {
    return _wishlistItems.where((item) => item.isNewAlert).length;
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text('홈'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            Text(
              '마이페이지',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              '마이페이지',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${profile.nickname}님의 정보와 저장한 상품 활동을 관리해요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

class _SideNavCard extends StatelessWidget {
  const _SideNavCard({
    required this.profile,
    required this.onTopTap,
    required this.onCartTap,
    required this.onWishlistTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onSettingsTap,
  });

  final UserProfile profile;
  final VoidCallback onTopTap;
  final VoidCallback onCartTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    profile.initials,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  profile.nickname.isEmpty ? '사용자' : profile.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      profile.role.isEmpty
                          ? '일반 회원 (무료)'
                          : '${profile.role} 회원',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _SideNavItem(
            icon: Icons.home_outlined,
            label: '마이페이지',
            selected: true,
            onTap: onTopTap,
          ),
          _SideNavItem(
            icon: Icons.inventory_2_outlined,
            label: '주문/배송',
            onTap: onCartTap,
          ),
          _SideNavItem(
            icon: Icons.favorite_border,
            label: '저장한 상품',
            onTap: onWishlistTap,
          ),
          _SideNavItem(
            icon: Icons.history,
            label: '최근 본 상품',
            onTap: onRecentTap,
          ),
          _SideNavItem(
            icon: Icons.rate_review_outlined,
            label: '리뷰 활동',
            onTap: onReviewTap,
          ),
          _SideNavItem(
            icon: Icons.settings_outlined,
            label: '계정 설정',
            onTap: () => context.go(RoutePaths.settings),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    left: BorderSide(color: AppColors.primary, width: 3),
                  )
                : null,
          ),
          padding: EdgeInsets.only(
            left: selected ? AppSpacing.lg - 3 : AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textPrimary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({
    required this.wishlistCount,
    required this.recentCount,
    required this.riskyCount,
    required this.notificationCount,
    required this.onWishlistTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onNotificationTap,
  });

  final int wishlistCount;
  final int recentCount;
  final int riskyCount;
  final int notificationCount;
  final VoidCallback onWishlistTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final width = context.viewportSize.width;
    final columns = width < 700
        ? 1
        : width < 1100
        ? 2
        : 4;
    final stats = [
      _StatItem(
        icon: Icons.favorite_border,
        label: '저장한 상품',
        value: wishlistCount.toString(),
        onTap: onWishlistTap,
      ),
      _StatItem(
        icon: Icons.history,
        label: '최근 본 상품',
        value: recentCount.toString(),
        onTap: onRecentTap,
      ),
      _StatItem(
        icon: Icons.warning_amber_rounded,
        label: '주의 상품',
        value: riskyCount.toString(),
        onTap: onReviewTap,
      ),
      _StatItem(
        icon: Icons.notifications_none,
        label: '알림',
        value: notificationCount.toString(),
        onTap: onNotificationTap,
      ),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 92,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) => _StatCard(item: stats[index]),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: item.onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _SavedProductsSection extends StatelessWidget {
  const _SavedProductsSection({
    required this.items,
    required this.isLoading,
    required this.onProductTap,
  });

  final List<WishlistItem> items;
  final bool isLoading;
  final ValueChanged<int> onProductTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: AppLoadingView(message: '저장한 상품을 불러오는 중입니다.'),
      );
    }

    if (items.isEmpty) {
      return _EmptyPanel(icon: Icons.favorite_border, message: '저장한 상품이 없습니다.');
    }

    final columns = context.viewportSize.width < 760
        ? 1
        : context.viewportSize.width < 1120
        ? 2
        : 4;
    final displayItems = items.take(4).toList(growable: false);

    return GridView.builder(
      itemCount: displayItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 166,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return _CompactProductCard(
          title: item.name,
          subtitle: item.platform ?? item.categoryDisplayName,
          imageUrl: item.imageUrl,
          price: item.price,
          rating: item.avgRating,
          reviewCount: item.reviewCount,
          rtiLabel: item.avgRti == 0 ? '' : 'RTI ${item.avgRti.round()}',
          onTap: () => onProductTap(item.productId),
        );
      },
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({
    required this.savedItems,
    required this.recentProducts,
    required this.onProductTap,
  });

  final List<WishlistItem> savedItems;
  final List<DashboardProduct> recentProducts;
  final ValueChanged<String> onProductTap;

  @override
  Widget build(BuildContext context) {
    final activities = <_ActivityItem>[
      for (final item in savedItems.take(2))
        _ActivityItem(
          icon: Icons.favorite_border,
          title: '"${item.name}" 상품을 저장했어요.',
          trailing: _relativeDate(item.savedAt),
          onTap: () => onProductTap(item.productId.toString()),
        ),
      for (final item in recentProducts.take(2))
        _ActivityItem(
          icon: Icons.history,
          title: '"${item.name}" 상품을 확인했어요.',
          trailing: '최근',
          onTap: () => onProductTap(item.id),
        ),
    ];

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PanelTitle(title: '최근 활동'),
          const SizedBox(height: AppSpacing.sm),
          if (activities.isEmpty)
            const _InlineEmpty(message: '최근 활동이 없습니다.')
          else
            for (final activity in activities) _ActivityTile(item: activity),
        ],
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback onTap;
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(item.icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              item.trailing,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _TrustSummaryPanel extends StatefulWidget {
  const _TrustSummaryPanel({
    required this.savedAverageRti,
    required this.riskyCount,
  });

  final double? savedAverageRti;
  final int riskyCount;

  @override
  State<_TrustSummaryPanel> createState() => _TrustSummaryPanelState();
}

class _TrustSummaryPanelState extends State<_TrustSummaryPanel> {
  bool _highlightRiskyReviews = true;
  bool _wishlistNotifications = true;

  @override
  Widget build(BuildContext context) {
    final score = widget.savedAverageRti?.clamp(0, 100).toDouble();
    final scoreText = score == null ? '-' : '${score.round()}점';

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PanelTitle(title: '리뷰 신뢰 요약'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  '관심 상품 평균 RTI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                scoreText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: score == null ? 0 : score / 100,
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            score == null
                ? '관심 상품을 저장하면 리뷰 신뢰도 요약이 표시됩니다.'
                : widget.riskyCount == 0
                ? '현재 대시보드에 주의가 필요한 상품이 없습니다.'
                : '주의 상품 ${widget.riskyCount}개를 확인해보세요.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(color: AppColors.border),
          _SettingRow(
            label: '주의 상품 먼저 보기',
            enabled: _highlightRiskyReviews,
            onChanged: (value) =>
                setState(() => _highlightRiskyReviews = value),
          ),
          const Divider(color: AppColors.border),
          _SettingRow(
            label: '저장 상품 알림 받기',
            enabled: _wishlistNotifications,
            onChanged: (value) =>
                setState(() => _wishlistNotifications = value),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(value: enabled, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({
    required this.profile,
    required this.onPasswordTap,
    required this.onSettingsTap,
  });

  final UserProfile profile;
  final VoidCallback onPasswordTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AccountItem(
        icon: Icons.person_outline,
        title: '계정 정보',
        subtitle: '개인 정보 및 기본 정보를 관리해요.',
        onTap: () => _showInfoDialog(
          context,
          title: '계정 정보',
          lines: [
            '닉네임: ${profile.nickname.isEmpty ? '사용자' : profile.nickname}',
            '이메일: ${profile.email}',
            '회원 유형: ${profile.role.isEmpty ? '일반 회원' : profile.role}',
          ],
        ),
      ),
      _AccountItem(
        icon: Icons.lock_outline,
        title: '로그인 정보',
        subtitle: '이메일, 로그인 수단을 관리해요.',
        onTap: () => _showInfoDialog(
          context,
          title: '로그인 정보',
          lines: [
            '로그인 이메일: ${profile.email}',
            '인증 상태: 로그인됨',
            '온보딩: ${profile.onboardingCompleted ? '완료' : '미완료'}',
          ],
        ),
      ),
      _AccountItem(
        icon: Icons.key_outlined,
        title: '비밀번호 변경',
        subtitle: '안전한 비밀번호로 관리하세요.',
        onTap: onPasswordTap,
      ),
      _AccountItem(
        icon: Icons.notifications_none,
        title: '알림 설정',
        subtitle: '이메일 및 푸시 알림을 설정해요.',
        onTap: onSettingsTap,
      ),
    ];

    final columns = context.viewportSize.width < 760 ? 1 : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: '계정 / 보안'),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 96,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemBuilder: (context, index) => _AccountTile(item: items[index]),
        ),
      ],
    );
  }

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required List<String> lines,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(line),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

class _AccountItem {
  const _AccountItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.item});

  final _AccountItem item;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: item.onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _CompactProductCard extends StatelessWidget {
  const _CompactProductCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.rtiLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final int price;
  final double rating;
  final int reviewCount;
  final String rtiLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
              dimension: 96,
              child: AppNetworkImage(url: imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatPrice(price),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${rating.toStringAsFixed(1)} ($reviewCount)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    if (rtiLabel.isNotEmpty)
                      Text(
                        rtiLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveTwoColumn extends StatelessWidget {
  const _ResponsiveTwoColumn({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (context.viewportSize.width < 980) {
      return Column(
        children: [
          left,
          const SizedBox(height: AppSpacing.md),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: AppSpacing.xl),
        Expanded(child: right),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onMore});

  final String title;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (onMore != null)
          TextButton.icon(
            onPressed: onMore,
            icon: const Icon(Icons.chevron_right, size: 16),
            iconAlignment: IconAlignment.end,
            label: const Text('전체 보기'),
          ),
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textTertiary, size: 34),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final box = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );

    if (onTap == null) return box;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: box,
      ),
    );
  }
}

String _formatPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return '$buffer원';
}

String _relativeDate(DateTime? date) {
  if (date == null) return '최근';
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 1) return '${diff.inDays}일 전';
  if (diff.inHours >= 1) return '${diff.inHours}시간 전';
  return '방금 전';
}
