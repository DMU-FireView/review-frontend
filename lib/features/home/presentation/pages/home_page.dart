import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/benefit_cta.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_footer.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/popular_category_section.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/product_recommendation_section.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/quick_category_row.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/review_trust_info_card.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/trending_keyword_chips.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  final _searchFocusNode = FocusNode();
  final _heroKey = GlobalKey();
  final _categoryKey = GlobalKey();
  final _recommendationKey = GlobalKey();
  final _benefitKey = GlobalKey();
  final _popularCategoryKey = GlobalKey();
  String _selectedNavItem = '홈';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useWideCommerceGrid = context.viewportSize.width >= 1120;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final dashboardProducts = _recommendedProductsFrom(dashboardState);
    final dashboardKeywords = _trendingKeywordsFrom(dashboardState);
    final page = Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: _selectedNavItem,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.login),
              onCartPressed: () => context.go(RoutePaths.login),
              onNavItemPressed: _handleNavItemPressed,
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: _handleSearchSubmitted,
              searchKeywords: dashboardKeywords,
              searchRecommendedProducts: dashboardProducts,
              searchFocusNode: _searchFocusNode,
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onMyPagePressed: () => context.go(RoutePaths.login),
              onProfileWishPressed: () => context.go(RoutePaths.login),
              onProfileOrderPressed: () => context.go(RoutePaths.login),
              onLogoutPressed: _handleLogout,
            ),
          ),
          if (_selectedNavItem == '홈') ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: context.isMobile ? 20 : 28),
                child: _FadeUp(
                  key: _heroKey,
                  delay: 0,
                  child: HeroBannerCarousel(
                    items: banners,
                    onBannerPressed: _handleBannerPressed,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AppContentView(
                maxWidth: 1440,
                padding: _homeContentPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FadeUp(
                      key: _categoryKey,
                      delay: 60,
                      child: QuickCategoryRow(
                        items: quickCategories,
                        onCategoryPressed: _handleCategoryPressed,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (dashboardState is HomeDashboardLoading) ...[
                      const SizedBox(
                        height: 240,
                        child: AppLoadingView(message: '홈 데이터를 불러오는 중입니다.'),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ] else if (dashboardState is HomeDashboardFailure) ...[
                      SizedBox(
                        height: 280,
                        child: AppErrorView(
                          message: dashboardState.failure.message,
                          onRetry: () => ref
                              .read(homeDashboardViewModelProvider.notifier)
                              .refresh(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ] else ...[
                      _FadeUp(
                        delay: 120,
                        child: TrendingKeywordChips(keywords: dashboardKeywords),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  if (useWideCommerceGrid) ...[
                    _FadeUp(
                      key: _recommendationKey,
                      delay: 180,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              '에디터가 고른 리뷰 기반 추천 상품',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: AppSpacing.xxs,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: AppColors.textSecondary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '전체보기',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.chevron_right, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 13,
                          child: ProductRecommendationSection(
                            showHeader: false,
                            products: dashboardProducts,
                            onProductTap: _handleProductPressed,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FadeUp(
                                delay: 240,
                                child: ReviewTrustInfoCard(),
                              ),
                              const SizedBox(height: 20),
                              _FadeUp(
                                key: _benefitKey,
                                delay: 300,
                                child: BenefitCTA(
                                  items: benefitItems,
                                  onBenefitPressed: () =>
                                      context.go(RoutePaths.login),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _FadeUp(
                      key: _popularCategoryKey,
                      delay: 360,
                      child: PopularCategorySection(
                        items: popularCategories,
                        onCategoryPressed: _handleCategoryPressed,
                      ),
                    ),
                  ]
                  else ...[
                    _FadeUp(
                      key: _recommendationKey,
                      delay: 180,
                      child: ProductRecommendationSection(
                        products: dashboardProducts,
                        onProductTap: _handleProductPressed,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _FadeUp(delay: 240, child: ReviewTrustInfoCard()),
                    const SizedBox(height: AppSpacing.xl),
                    _FadeUp(
                      key: _benefitKey,
                      delay: 300,
                      child: BenefitCTA(
                        items: benefitItems,
                        onBenefitPressed: () => context.go(RoutePaths.login),
                      ),
                    ),
                  ],
                  if (!useWideCommerceGrid) ...[
                    const SizedBox(height: AppSpacing.xl),
                    _FadeUp(
                      key: _popularCategoryKey,
                      delay: 360,
                      child: PopularCategorySection(
                        items: popularCategories,
                        onCategoryPressed: _handleCategoryPressed,
                      ),
                    ),
                  ],
                  SizedBox(height: context.isMobile ? 96 : AppSpacing.xxxl),
                ],
              ),
            ),
          ),
          ] else ...[
            SliverToBoxAdapter(
              child: _HomeTabPlaceholder(tab: _selectedNavItem),
            ),
          ],
          const SliverToBoxAdapter(child: HomeFooter()),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? _HomeBottomTabs(
              onHomePressed: () => _handleNavItemPressed('홈'),
              onCategoryPressed: () => _scrollTo(_categoryKey),
              onSearchPressed: () => _searchFocusNode.requestFocus(),
              onWishPressed: () => _handleNavItemPressed('베스트'),
              onMyPressed: () => context.go(RoutePaths.login),
            )
          : null,
    );

    return page;
  }

  EdgeInsets _homeContentPadding(BuildContext context) {
    if (context.isMobile) {
      return const EdgeInsets.fromLTRB(16, 20, 16, 0);
    }

    if (context.isTablet) {
      return const EdgeInsets.fromLTRB(24, 28, 24, 0);
    }

    return const EdgeInsets.fromLTRB(32, 28, 32, 0);
  }

  void _handleNavItemPressed(String item) {
    setState(() => _selectedNavItem = item);
    _scrollController.jumpTo(0);
  }

  void _handleCategoryPressed(String label) {
    if (label == '전체보기') {
      _scrollTo(_popularCategoryKey);
      return;
    }

    setState(() => _selectedNavItem = label);
    _scrollTo(_recommendationKey);
  }

  void _handleBannerPressed(HomeBannerData banner) {
    _scrollTo(_recommendationKey);
  }

  void _handleLogout() {
    ref.read(authTokenStoreProvider.notifier).clear();
    context.go(RoutePaths.landing);
  }

  void _handleProductPressed(HomeProductData product) {
    context.go('/product/${product.productId}');
  }

  void _handleSearchSubmitted(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }

    context.goNamed(RouteNames.search, queryParameters: {'q': query});
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  List<HomeProductData> _recommendedProductsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(dashboard: final dashboard) =>
        dashboard.recommendedProducts
            .map(_toHomeProductData)
            .toList(growable: false),
      _ => const [],
    };
  }

  List<String> _trendingKeywordsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(dashboard: final dashboard) =>
        dashboard.trendingKeywords
            .map(_toKeywordLabel)
            .where((keyword) => keyword.isNotEmpty)
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

  String _toKeywordLabel(TrendingKeyword keyword) => keyword.keyword;

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
}

class _FadeUp extends StatefulWidget {
  const _FadeUp({required this.child, required this.delay, super.key});

  final Widget child;
  final int delay;

  @override
  State<_FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<_FadeUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _timer = Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class _HomeTabPlaceholder extends StatelessWidget {
  const _HomeTabPlaceholder({required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_outlined, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text(
            tab,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '준비 중인 콘텐츠입니다.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomTabs extends StatelessWidget {
  const _HomeBottomTabs({
    required this.onHomePressed,
    required this.onCategoryPressed,
    required this.onSearchPressed,
    required this.onWishPressed,
    required this.onMyPressed,
  });

  final VoidCallback onHomePressed;
  final VoidCallback onCategoryPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onMyPressed;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_filled, '홈'),
      (Icons.grid_view_outlined, '카테고리'),
      (Icons.search, '검색'),
      (Icons.favorite_border, '찜'),
      (Icons.person_outline, '마이'),
    ];
    final callbacks = [
      onHomePressed,
      onCategoryPressed,
      onSearchPressed,
      onWishPressed,
      onMyPressed,
    ];

    return Container(
      height: 72 + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: callbacks[i],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[i].$1,
                      color: items[i].$2 == '홈'
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      size: 27,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      items[i].$2,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: items[i].$2 == '홈'
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: items[i].$2 == '홈'
                            ? FontWeight.w900
                            : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
