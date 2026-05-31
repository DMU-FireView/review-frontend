import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/shared/extensions/context_extensions.dart';

typedef SearchSuggestionsRequested =
    Future<List<String>> Function(String query);

const _categoryImageBasePath = 'assets/images/categories/category_images';

const _categoryImageAssets = {
  'digital-appliance': '$_categoryImageBasePath/cat_digital_camera.png',
  'fashion-clothing': '$_categoryImageBasePath/cat_fashion_clothing.png',
  'fashion-accessory': '$_categoryImageBasePath/cat_bag_wallet.png',
  'beauty': '$_categoryImageBasePath/cat_beauty_cosmetic.png',
  'food': '$_categoryImageBasePath/cat_food_fresh.png',
  'living-kitchen': '$_categoryImageBasePath/cat_living_kitchen.png',
  'furniture-interior': '$_categoryImageBasePath/cat_furniture_interior.png',
  'sports-leisure': '$_categoryImageBasePath/sports_fitness_yoga.png',
  'car-tools': '$_categoryImageBasePath/auto_supplies.png',
  'baby-kids': '$_categoryImageBasePath/cat_baby_kids.png',
  'pet': '$_categoryImageBasePath/cat_pet_supplies.png',
  'book-stationery-hobby': '$_categoryImageBasePath/books.png',
  'travel-service': '$_categoryImageBasePath/travel_supplies.png',
  'luxury-brand': '$_categoryImageBasePath/luxury_wallet_watch.png',
  'mobile-tablet': '$_categoryImageBasePath/digital_mobile_tablet.png',
  'pc-peripheral': '$_categoryImageBasePath/digital_pc_laptop.png',
  'video-audio': '$_categoryImageBasePath/digital_video_audio.png',
  'living-appliance': '$_categoryImageBasePath/digital_life_appliance.png',
  'kitchen-appliance': '$_categoryImageBasePath/digital_kitchen_appliance.png',
  'women-clothing': '$_categoryImageBasePath/fashion_womens_clothing.png',
  'men-clothing': '$_categoryImageBasePath/fashion_mens_clothing.png',
  'underwear-homewear':
      '$_categoryImageBasePath/fashion_underwear_loungewear.png',
  'sports-clothing': '$_categoryImageBasePath/fashion_sportswear.png',
  'shoes': '$_categoryImageBasePath/fashion_sneakers_shoes.png',
  'bags': '$_categoryImageBasePath/fashion_bag.png',
  'wallet-belt': '$_categoryImageBasePath/fashion_wallet_belt.png',
  'accessory': '$_categoryImageBasePath/fashion_watch_accessory.png',
  'skincare': '$_categoryImageBasePath/beauty_skincare.png',
  'makeup': '$_categoryImageBasePath/beauty_makeup.png',
  'cleansing': '$_categoryImageBasePath/beauty_cleansing.png',
  'haircare': '$_categoryImageBasePath/beauty_haircare.png',
  'bodycare': '$_categoryImageBasePath/beauty_bodycare.png',
  'fresh-food': '$_categoryImageBasePath/food_fresh.png',
  'processed-food': '$_categoryImageBasePath/food_processed.png',
  'snack-dessert': '$_categoryImageBasePath/food_snacks_dessert.png',
  'beverage': '$_categoryImageBasePath/food_drinks.png',
  'health-food': '$_categoryImageBasePath/food_health.png',
  'daily-supplies': '$_categoryImageBasePath/living_daily_supplies.png',
  'kitchenware': '$_categoryImageBasePath/living_kitchen_supplies.png',
  'storage-organization':
      '$_categoryImageBasePath/living_storage_organizing.png',
  'safety-tools': '$_categoryImageBasePath/living_safety_tools.png',
  'furniture': '$_categoryImageBasePath/home_furniture.png',
  'bedding': '$_categoryImageBasePath/home_bedding.png',
  'home-deco': '$_categoryImageBasePath/home_decor.png',
  'diy-construction': '$_categoryImageBasePath/home_diy.png',
  'health-yoga': '$_categoryImageBasePath/sports_fitness_yoga.png',
  'hiking-camping': '$_categoryImageBasePath/sports_camping_hiking.png',
  'bicycle-board': '$_categoryImageBasePath/sports_bicycle_board.png',
  'golf': '$_categoryImageBasePath/sports_golf.png',
  'car-supplies': '$_categoryImageBasePath/auto_supplies.png',
  'motorcycle-supplies': '$_categoryImageBasePath/motorcycle_supplies.png',
  'industrial-tools': '$_categoryImageBasePath/tools_industrial_supplies.png',
  'birth-childcare': '$_categoryImageBasePath/baby_outing.png',
  'baby-supplies': '$_categoryImageBasePath/baby_food_tableware.png',
  'kids-clothing': '$_categoryImageBasePath/baby_clothing.png',
  'toys-education': '$_categoryImageBasePath/kids_toys_education.png',
  'dog-supplies': '$_categoryImageBasePath/pet_dog_supplies.png',
  'cat-supplies': '$_categoryImageBasePath/pet_cat_supplies.png',
  'small-pet-aquarium': '$_categoryImageBasePath/pet_small_animals_fish.png',
  'book': '$_categoryImageBasePath/books.png',
  'stationery-office': '$_categoryImageBasePath/stationery_office.png',
  'hobby': '$_categoryImageBasePath/hobby_musical_instrument.png',
  'ticket-goods': '$_categoryImageBasePath/tickets_goods.png',
  'travel-supplies': '$_categoryImageBasePath/travel_supplies.png',
  'accommodation-ticket': '$_categoryImageBasePath/hotel_ticket.png',
  'rental-subscription': '$_categoryImageBasePath/rental_subscription.png',
  'luxury-accessory': '$_categoryImageBasePath/luxury_wallet_watch.png',
  'brand-fashion': '$_categoryImageBasePath/brand_fashion.png',
  'premium-beauty': '$_categoryImageBasePath/premium_beauty.png',
};

const _defaultBenefitLabels = [
  '리뷰 데이터 기반 추천',
  'RTI 랭킹 확인',
  '빠른 배송 상품',
  '혜택 모아보기',
];

const _categoryBenefitLabels = {
  'digital-appliance': ['리뷰 데이터 기반 추천', 'RTI 랭킹 확인', '빠른 배송 상품', '혜택 모아보기'],
  'fashion-clothing': ['사이즈 추천', '스타일 추천', '성별 핫딜', '베스트 선물'],
  'fashion-accessory': ['정품 인증', '브랜드 기획전', '선물 포장 서비스', '무료 반품'],
  'beauty': ['성분으로 찾기', '피부 타입 추천', '리뷰 랭킹', '샘플 체험'],
  'food': ['새벽배송', '대용량 할인', '리뷰 인기상품', '정기배송'],
  'living-kitchen': ['오늘의 특가', '집들이 추천', '리뷰 랭킹', '빠른배송'],
  'furniture-interior': ['공간별 추천', '인기 인테리어', '설치 서비스', '시즌 데코'],
  'sports-leisure': ['입문자 추천', '베스트 장비', '시즌 아웃도어', '빠른 비교'],
  'car-tools': ['차량관리 필수템', '정비용품 추천', '브랜드 특가', '안전장비 모음'],
  'baby-kids': ['육아 필수템', '연령별 추천', '안전인증', '기획전'],
  'pet': ['인기 간식', '정기배송', '수의사 추천', '우리 아이 맞춤'],
  'book-stationery-hobby': ['MD 추천', '예약판매', '한정판 굿즈', '베스트셀러'],
  'travel-service': ['여행 준비 체크리스트', '인기 숙소', '할인 티켓', '구독 혜택'],
  'luxury-brand': ['정품 보증', '브랜드 위크', '프리미엄 혜택', '단독 오퍼'],
};

String? _categoryAssetPath(String categoryId) =>
    _categoryImageAssets[categoryId];

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.navItems,
    required this.selectedNavItem,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.showCategoryNav = true,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.onSearchSubmitted,
    this.onLogoPressed,
    this.searchFocusNode,
    this.cartCount,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
    super.key,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final bool showCategoryNav;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onLogoPressed;
  final FocusNode? searchFocusNode;
  final int? cartCount;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final useCompactHeader =
        context.isMobile || context.viewportSize.width < 1100;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.md,
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: useCompactHeader
              ? _MobileHeader(
                  onLogoPressed: onLogoPressed,
                  onLoginPressed: onLoginPressed,
                  onNotificationPressed: onLoginPressed,
                  onCartPressed: onCartPressed,
                  onSearchSubmitted: onSearchSubmitted,
                  searchKeywords: searchKeywords,
                  searchRecommendedProducts: searchRecommendedProducts,
                  onSearchSuggestionsRequested: onSearchSuggestionsRequested,
                  searchFocusNode: searchFocusNode,
                  isLoggedIn: isLoggedIn,
                  nickname: nickname,
                  onMyPagePressed: onMyPagePressed,
                  onProfileWishPressed: onProfileWishPressed,
                  onProfileOrderPressed: onProfileOrderPressed,
                  onLogoutPressed: onLogoutPressed,
                )
              : _DesktopHeader(
                  navItems: navItems,
                  selectedNavItem: selectedNavItem,
                  showCategoryNav: showCategoryNav,
                  onLoginPressed: onLoginPressed,
                  onWishPressed: onWishPressed,
                  onCartPressed: onCartPressed,
                  onNavItemPressed: onNavItemPressed,
                  onSearchSubmitted: onSearchSubmitted,
                  searchKeywords: searchKeywords,
                  searchRecommendedProducts: searchRecommendedProducts,
                  onSearchSuggestionsRequested: onSearchSuggestionsRequested,
                  onLogoPressed: onLogoPressed,
                  searchFocusNode: searchFocusNode,
                  cartCount: cartCount,
                  isLoggedIn: isLoggedIn,
                  nickname: nickname,
                  onMyPagePressed: onMyPagePressed,
                  onProfileWishPressed: onProfileWishPressed,
                  onProfileOrderPressed: onProfileOrderPressed,
                  onLogoutPressed: onLogoutPressed,
                ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({
    required this.navItems,
    required this.selectedNavItem,
    required this.showCategoryNav,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.onSearchSubmitted,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.onLogoPressed,
    this.searchFocusNode,
    this.cartCount,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final bool showCategoryNav;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final ValueChanged<String>? onSearchSubmitted;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final VoidCallback? onLogoPressed;
  final FocusNode? searchFocusNode;
  final int? cartCount;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final searchWidth = (context.viewportSize.width * 0.34).clamp(440.0, 560.0);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 360,
              child: Row(
                children: [
                  HomeLogo(onTap: onLogoPressed),
                  const SizedBox(width: AppSpacing.xxl),
                  _TopLink(label: '고객센터', onTap: onLoginPressed),
                  const SizedBox(width: AppSpacing.lg),
                  _TopLink(label: '판매자 입점', onTap: onLoginPressed),
                  const SizedBox(width: AppSpacing.lg),
                  _TopLink(label: '앱 다운로드', onTap: onLoginPressed),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: searchWidth,
                  child: home.SearchBar(
                    focusNode: searchFocusNode,
                    popularKeywords: searchKeywords,
                    recommendedProducts: searchRecommendedProducts,
                    onSuggestionsRequested: onSearchSuggestionsRequested,
                    onSubmitted: onSearchSubmitted,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isLoggedIn) ...[
                    _UserProfileButton(
                      nickname: nickname,
                      onMyPagePressed: onMyPagePressed,
                      onProfileWishPressed: onProfileWishPressed,
                      onProfileOrderPressed: onProfileOrderPressed,
                      onLogoutPressed: onLogoutPressed,
                    ),
                    _HeaderAction(
                      icon: Icons.favorite_border,
                      label: '찜',
                      onTap: onWishPressed,
                    ),
                    _HeaderAction(
                      icon: Icons.shopping_cart_outlined,
                      label: '장바구니',
                      onTap: onCartPressed,
                      badge: cartCount == null || cartCount == 0
                          ? null
                          : '$cartCount',
                    ),
                  ] else ...[
                    _HeaderAction(
                      icon: Icons.person_outline,
                      label: '로그인',
                      onTap: onLoginPressed,
                    ),
                    _HeaderAction(
                      icon: Icons.favorite_border,
                      label: '찜',
                      onTap: onWishPressed,
                    ),
                    _HeaderAction(
                      icon: Icons.shopping_cart_outlined,
                      label: '장바구니',
                      onTap: onCartPressed,
                      badge: cartCount == null || cartCount == 0
                          ? null
                          : '$cartCount',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (showCategoryNav) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _CategoryMenuButton(onCategorySelected: onNavItemPressed),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in navItems)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xl),
                          child: TextButton(
                            onPressed: () => onNavItemPressed(item),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: item == selectedNavItem
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: item == selectedNavItem
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    fontWeight: item == selectedNavItem
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CategoryMenuButton extends StatefulWidget {
  const _CategoryMenuButton({required this.onCategorySelected});

  final ValueChanged<String> onCategorySelected;

  @override
  State<_CategoryMenuButton> createState() => _CategoryMenuButtonState();
}

class _CategoryMenuButtonState extends State<_CategoryMenuButton> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _openMenu();
    } else {
      _closeMenu();
    }
  }

  void _openMenu() {
    final overlay = Overlay.of(context);
    final buttonBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (buttonBox == null || overlayBox == null) {
      return;
    }

    final buttonOffset = buttonBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final overlayWidth = overlayBox.size.width;
    final panelWidth = overlayWidth < 1488 ? overlayWidth - 32 : 1440.0;
    final panelLeft = (overlayWidth - panelWidth) / 2;
    final panelTop = buttonOffset.dy + buttonBox.size.height + 12;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: panelLeft,
              top: panelTop,
              width: panelWidth,
              child: _CategoryMegaMenuPanel(
                onCategorySelected: (label) {
                  widget.onCategorySelected(label);
                  _closeMenu();
                },
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
    setState(() {});
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: _toggleMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '카테고리',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryMegaMenuPanel extends StatefulWidget {
  const _CategoryMegaMenuPanel({required this.onCategorySelected});

  final ValueChanged<String> onCategorySelected;

  @override
  State<_CategoryMegaMenuPanel> createState() => _CategoryMegaMenuPanelState();
}

class _CategoryMegaMenuPanelState extends State<_CategoryMegaMenuPanel> {
  ProductCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: SizedBox(
          height: 392,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategorySideNav(
                selectedCategory: _selectedCategory,
                onAllPressed: () => setState(() => _selectedCategory = null),
                onCategoryPressed: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const VerticalDivider(width: 1, color: AppColors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
                  child: _selectedCategory == null
                      ? _AllCategoryOverview(
                          onCategorySelected: widget.onCategorySelected,
                        )
                      : _SelectedCategoryView(
                          category: _selectedCategory!,
                          onCategorySelected: widget.onCategorySelected,
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

class _CategorySideNav extends StatelessWidget {
  const _CategorySideNav({
    required this.selectedCategory,
    required this.onAllPressed,
    required this.onCategoryPressed,
  });

  final ProductCategory? selectedCategory;
  final VoidCallback onAllPressed;
  final ValueChanged<ProductCategory> onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategorySideNavItem(
              label: '전체보기',
              isSelected: selectedCategory == null,
              onTap: onAllPressed,
            ),
            for (final category in productCategoryTree)
              _CategorySideNavItem(
                label: category.label,
                isSelected: selectedCategory?.id == category.id,
                onTap: () => onCategoryPressed(category),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategorySideNavItem extends StatelessWidget {
  const _CategorySideNavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 24,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: AppColors.primary) : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AllCategoryOverview extends StatelessWidget {
  const _AllCategoryOverview({required this.onCategorySelected});

  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = productCategoryTree.take(10).toList(growable: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모든 카테고리를 한눈에',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '리뷰 데이터 기반 인기 상품과 카테고리를 확인해보세요.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.22,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryOverviewTile(
                      category: category,
                      onTap: () => onCategorySelected(category.label),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 3,
          child: _PopularCategoryPreview(
            onCategorySelected: onCategorySelected,
          ),
        ),
      ],
    );
  }
}

class _SelectedCategoryView extends StatelessWidget {
  const _SelectedCategoryView({
    required this.category,
    required this.onCategorySelected,
  });

  final ProductCategory category;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in category.children) ...[
                Expanded(
                  child: _MiddleCategoryColumn(
                    category: child,
                    onCategorySelected: onCategorySelected,
                  ),
                ),
                if (child != category.children.last)
                  const VerticalDivider(width: 28, color: AppColors.border),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _CategoryBenefitStrip(category: category),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => onCategorySelected(category.label),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            ),
            child: Text('${category.label} 전체보기  >'),
          ),
        ),
      ],
    );
  }
}

class _MiddleCategoryColumn extends StatelessWidget {
  const _MiddleCategoryColumn({
    required this.category,
    required this.onCategorySelected,
  });

  final ProductCategory category;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onCategorySelected(category.label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 84,
              child: Align(
                alignment: Alignment.centerRight,
                child: _CategoryAssetImage(
                  assetPath: _categoryAssetPath(category.id),
                  width: 128,
                  height: 84,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in category.children.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryOverviewTile extends StatelessWidget {
  const _CategoryOverviewTile({required this.category, required this.onTap});

  final ProductCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: _CategoryAssetImage(
                    assetPath: _categoryAssetPath(category.id),
                    width: 108,
                    height: 82,
                  ),
                ),
              ),
              Text(
                category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                category.children.take(2).map((item) => item.label).join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularCategoryPreview extends StatelessWidget {
  const _PopularCategoryPreview({required this.onCategorySelected});

  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = productCategoryTree.take(5).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지금 인기 카테고리',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (final category in categories)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onCategorySelected(category.label),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: _CategoryAssetImage(
                          assetPath: _categoryAssetPath(category.id),
                          width: 46,
                          height: 46,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        category.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          '카테고리 추천 PICK',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.28,
            children: [
              for (final category in categories.take(4))
                _CategoryPickCard(
                  category: category,
                  onTap: () => onCategorySelected(category.label),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryPickCard extends StatelessWidget {
  const _CategoryPickCard({required this.category, required this.onTap});

  final ProductCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      category.children.first.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _CategoryAssetImage(
                assetPath: _categoryAssetPath(category.id),
                width: 52,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBenefitStrip extends StatelessWidget {
  const _CategoryBenefitStrip({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final items = _categoryBenefitLabels[category.id] ?? _defaultBenefitLabels;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC7D7FE)),
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
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

class _CategoryAssetImage extends StatelessWidget {
  const _CategoryAssetImage({
    required this.assetPath,
    required this.width,
    required this.height,
  });

  final String? assetPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null) {
      return Icon(
        Icons.category_outlined,
        color: AppColors.textTertiary,
        size: height * 0.48,
      );
    }

    return Image.asset(
      assetPath!,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.category_outlined,
        color: AppColors.textTertiary,
        size: height * 0.48,
      ),
    );
  }
}

class _TopLink extends StatelessWidget {
  const _TopLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({
    this.onLogoPressed,
    required this.onLoginPressed,
    required this.onNotificationPressed,
    required this.onCartPressed,
    this.onSearchSubmitted,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.searchFocusNode,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
  });

  final VoidCallback? onLogoPressed;
  final VoidCallback onLoginPressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String>? onSearchSubmitted;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final FocusNode? searchFocusNode;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: onLogoPressed),
            const Spacer(),
            if (isLoggedIn)
              _UserProfileButton(
                nickname: nickname,
                onMyPagePressed: onMyPagePressed,
                onProfileWishPressed: onProfileWishPressed,
                onProfileOrderPressed: onProfileOrderPressed,
                onLogoutPressed: onLogoutPressed,
                compact: true,
              )
            else
              IconButton(
                tooltip: '로그인',
                onPressed: onLoginPressed,
                icon: const Icon(Icons.person_outline),
              ),
            IconButton(
              tooltip: '장바구니',
              onPressed: onCartPressed,
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        home.SearchBar(
          focusNode: searchFocusNode,
          popularKeywords: searchKeywords,
          recommendedProducts: searchRecommendedProducts,
          onSuggestionsRequested: onSearchSuggestionsRequested,
          onSubmitted: onSearchSubmitted,
        ),
      ],
    );
  }
}

class _UserProfileButton extends StatefulWidget {
  const _UserProfileButton({
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
    this.compact = false,
  });

  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;
  final bool compact;

  @override
  State<_UserProfileButton> createState() => _UserProfileButtonState();
}

class _UserProfileButtonState extends State<_UserProfileButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  String _maskName(String name) {
    if (name.length <= 1) return name;
    return name[0] + '*' * (name.length - 1);
  }

  void _toggle() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 8),
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              child: GestureDetector(
                onTap: () {},
                child: _ProfileDropdown(
                  nickname: widget.nickname,
                  onMyPagePressed: () {
                    _removeOverlay();
                    widget.onMyPagePressed?.call();
                  },
                  onProfileWishPressed: () {
                    _removeOverlay();
                    widget.onProfileWishPressed?.call();
                  },
                  onProfileOrderPressed: () {
                    _removeOverlay();
                    widget.onProfileOrderPressed?.call();
                  },
                  onLogoutPressed: () {
                    _removeOverlay();
                    widget.onLogoutPressed?.call();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.nickname != null && widget.nickname!.isNotEmpty
        ? _maskName(widget.nickname!)
        : '내 계정';

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: widget.compact
              ? Icon(
                  Icons.person,
                  size: 24,
                  color: _isOpen ? AppColors.primary : AppColors.textPrimary,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 24,
                      color: _isOpen
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: _isOpen
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 14,
                          color: _isOpen
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  const _ProfileDropdown({
    this.nickname,
    required this.onMyPagePressed,
    required this.onProfileWishPressed,
    required this.onProfileOrderPressed,
    required this.onLogoutPressed,
  });

  final String? nickname;
  final VoidCallback onMyPagePressed;
  final VoidCallback onProfileWishPressed;
  final VoidCallback onProfileOrderPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final displayName = nickname != null && nickname!.isNotEmpty
        ? nickname!
        : '회원';

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty ? displayName[0] : '?',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$displayName님',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Re:view 멤버',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            _DropdownItem(
              icon: Icons.person_outline,
              label: '마이페이지',
              onTap: onMyPagePressed,
            ),
            _DropdownItem(
              icon: Icons.favorite_border,
              label: '찜한 상품',
              onTap: onProfileWishPressed,
            ),
            _DropdownItem(
              icon: Icons.receipt_long_outlined,
              label: '주문/활동',
              onTap: onProfileOrderPressed,
            ),
            const Divider(height: 1, color: AppColors.border),
            _DropdownItem(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: onLogoutPressed,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  const _DropdownItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 24, color: AppColors.textPrimary);

    return InkWell(
      borderRadius: AppRadius.small,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badge == null
                ? iconWidget
                : Badge(label: Text(badge!), child: iconWidget),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
