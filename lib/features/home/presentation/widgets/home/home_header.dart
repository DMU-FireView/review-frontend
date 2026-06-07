import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

typedef SearchSuggestionsRequested =
    Future<List<String>> Function(String query);

const _categoryImageBasePath = 'assets/images/categories/category_images';

const _categoryImageAssets = {
  'digital-appliance':
      '$_categoryImageBasePath/58_digital_mobile_tablet_camera.png',
  'fashion-clothing':
      '$_categoryImageBasePath/59_fashion_womens_clothing_jacket.png',
  'fashion-accessory': '$_categoryImageBasePath/60_fashion_bag_handbag.png',
  'beauty': '$_categoryImageBasePath/61_beauty_skincare_cosmetics.png',
  'food': '$_categoryImageBasePath/62_food_fresh_fruits.png',
  'living-kitchen':
      '$_categoryImageBasePath/63_living_kitchen_supplies_cookware.png',
  'furniture-interior': '$_categoryImageBasePath/64_home_furniture_chair.png',
  'sports-leisure':
      '$_categoryImageBasePath/65_sports_camping_hiking_character.png',
  'car-tools': '$_categoryImageBasePath/35_car_accessories_cleaning_tools.png',
  'baby-kids': '$_categoryImageBasePath/66_baby_clothing_baby.png',
  'pet': '$_categoryImageBasePath/67_pet_dog_supplies_retriever.png',
  'book-stationery-hobby':
      '$_categoryImageBasePath/08_books_stack_open_book.png',
  'travel-service':
      '$_categoryImageBasePath/11_travel_luggage_packing_cubes_neck_pillow.png',
  'luxury-brand': '$_categoryImageBasePath/15_luxury_bag_wallet_watch_set.png',
  'mobile-tablet':
      '$_categoryImageBasePath/41_digital_mobile_tablet_smartphone.png',
  'pc-peripheral':
      '$_categoryImageBasePath/42_digital_pc_laptop_keyboard_mouse.png',
  'video-audio': '$_categoryImageBasePath/43_digital_video_audio_tv.png',
  'living-appliance':
      '$_categoryImageBasePath/44_digital_life_appliance_air_purifier.png',
  'kitchen-appliance':
      '$_categoryImageBasePath/45_digital_kitchen_appliance_air_fryer.png',
  'women-clothing':
      '$_categoryImageBasePath/46_fashion_womens_clothing_jacket.png',
  'men-clothing': '$_categoryImageBasePath/47_fashion_mens_clothing_jacket.png',
  'underwear-homewear':
      '$_categoryImageBasePath/48_fashion_underwear_loungewear_camisole.png',
  'sports-clothing':
      '$_categoryImageBasePath/49_fashion_sportswear_training_jacket.png',
  'shoes': '$_categoryImageBasePath/50_fashion_sneakers_shoes_white.png',
  'bags': '$_categoryImageBasePath/51_fashion_bag_shoulder.png',
  'wallet-belt': '$_categoryImageBasePath/52_fashion_wallet_belt_black.png',
  'accessory': '$_categoryImageBasePath/53_fashion_watch_accessory_silver.png',
  'skincare': '$_categoryImageBasePath/39_beauty_skincare_set.png',
  'makeup': '$_categoryImageBasePath/54_beauty_makeup_lipstick_blush.png',
  'cleansing': '$_categoryImageBasePath/55_beauty_cleansing_oil_water.png',
  'haircare':
      '$_categoryImageBasePath/56_beauty_haircare_shampoo_treatment.png',
  'bodycare': '$_categoryImageBasePath/57_beauty_bodycare_wash_lotion.png',
  'fresh-food': '$_categoryImageBasePath/18_fresh_food_meat_fish_eggs_milk.png',
  'processed-food': '$_categoryImageBasePath/69_food_processed_ramen.png',
  'snack-dessert':
      '$_categoryImageBasePath/19_processed_food_snacks_dessert.png',
  'beverage': '$_categoryImageBasePath/20_beverages_health_products.png',
  'health-food': '$_categoryImageBasePath/20_beverages_health_products.png',
  'daily-supplies': '$_categoryImageBasePath/70_living_daily_supplies_mop.png',
  'kitchenware': '$_categoryImageBasePath/22_kitchen_essentials_set.png',
  'storage-organization':
      '$_categoryImageBasePath/23_storage_organization_items.png',
  'safety-tools': '$_categoryImageBasePath/24_safety_tools_items.png',
  'furniture': '$_categoryImageBasePath/25_modern_furniture_set.png',
  'bedding': '$_categoryImageBasePath/26_bedding_linen_collection.png',
  'home-deco': '$_categoryImageBasePath/27_home_decor_items.png',
  'diy-construction':
      '$_categoryImageBasePath/28_diy_home_improvement_items.png',
  'health-yoga': '$_categoryImageBasePath/29_fitness_yoga_items.png',
  'hiking-camping': '$_categoryImageBasePath/30_camping_hiking_gear.png',
  'bicycle-board': '$_categoryImageBasePath/37_bicycle_scooter_safety_gear.png',
  'golf': '$_categoryImageBasePath/36_golf_sports_equipment.png',
  'car-supplies':
      '$_categoryImageBasePath/35_car_accessories_cleaning_tools.png',
  'motorcycle-supplies':
      '$_categoryImageBasePath/34_motorcycle_riding_gear_accessories.png',
  'industrial-tools':
      '$_categoryImageBasePath/33_work_tools_uniform_equipment.png',
  'birth-childcare':
      '$_categoryImageBasePath/01_baby_outing_stroller_diapers.png',
  'baby-supplies':
      '$_categoryImageBasePath/02_baby_feeding_bowl_lotion_duck_towel.png',
  'kids-clothing':
      '$_categoryImageBasePath/03_baby_clothing_cardigan_denim_jacket.png',
  'toys-education':
      '$_categoryImageBasePath/04_kids_toys_teddy_blocks_puzzle.png',
  'dog-supplies': '$_categoryImageBasePath/05_dog_supplies_puppy_food_bowl.png',
  'cat-supplies': '$_categoryImageBasePath/06_cat_supplies_cat_litter_tree.png',
  'small-pet-aquarium':
      '$_categoryImageBasePath/07_small_pet_bird_aquarium_set.png',
  'book': '$_categoryImageBasePath/08_books_stack_open_book.png',
  'stationery-office':
      '$_categoryImageBasePath/09_stationery_pens_notebook_calculator.png',
  'hobby': '$_categoryImageBasePath/10_hobby_guitar_paintbrush_robot.png',
  'ticket-goods':
      '$_categoryImageBasePath/14_ticket_goods_concert_mug_keyring.png',
  'travel-supplies':
      '$_categoryImageBasePath/11_travel_luggage_packing_cubes_neck_pillow.png',
  'accommodation-ticket':
      '$_categoryImageBasePath/12_hotel_resort_photo_and_travel_cards.png',
  'rental-subscription':
      '$_categoryImageBasePath/13_rental_subscription_box_appliance.png',
  'luxury-accessory':
      '$_categoryImageBasePath/15_luxury_bag_wallet_watch_set.png',
  'brand-fashion':
      '$_categoryImageBasePath/16_brand_fashion_trench_sneakers_sunglasses.png',
  'premium-beauty':
      '$_categoryImageBasePath/17_premium_beauty_bottle_perfume_device.png',
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

class HomeHeader extends ConsumerWidget {
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
    this.wishlistCount,
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
  final int? wishlistCount;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCompactHeader =
        context.isMobile || context.viewportSize.width < 1100;
    final effectiveCartCount =
        cartCount ?? ref.watch(cartItemCountProvider).value ?? 0;
    final effectiveWishlistCount =
        wishlistCount ?? ref.watch(wishlistItemCountProvider).value ?? 0;

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
                  cartCount: effectiveCartCount,
                  wishlistCount: effectiveWishlistCount,
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
    this.wishlistCount,
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
  final int? wishlistCount;
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
                    HeaderUserProfileButton(
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
                      badge: wishlistCount == null || wishlistCount == 0
                          ? null
                          : '$wishlistCount',
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
                      badge: wishlistCount == null || wishlistCount == 0
                          ? null
                          : '$wishlistCount',
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
              _CategoryMenuButton(
                products: searchRecommendedProducts,
                onCategorySelected: onNavItemPressed,
              ),
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
  const _CategoryMenuButton({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  State<_CategoryMenuButton> createState() => _CategoryMenuButtonState();
}

class _CategoryMenuButtonState extends State<_CategoryMenuButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  ScrollPosition? _scrollPosition;
  late final AnimationController _controller;
  late final Animation<double> _revealAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 120),
    );
    final revealCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _revealAnim = revealCurve;
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.72, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );
    _scaleAnim = Tween<double>(begin: 0.985, end: 1).animate(revealCurve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition == nextPosition) return;

    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollActivity);
    _scrollPosition = nextPosition;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScrollActivity);
  }

  @override
  void dispose() {
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollActivity);
    _controller.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _handleScrollActivity() {
    if (_scrollPosition?.isScrollingNotifier.value ?? false) {
      _closeMenu(animate: false);
    }
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _openMenu();
    } else {
      _closeMenu();
    }
  }

  void _openMenu() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final buttonBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (buttonBox == null || overlayBox == null) return;

    final buttonOffset = buttonBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final overlayWidth = overlayBox.size.width;
    final panelTop = buttonOffset.dy + buttonBox.size.height + 1;

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
              left: 0,
              top: panelTop,
              width: overlayWidth,
              child: AnimatedBuilder(
                animation: _revealAnim,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _revealAnim.value,
                      child: child,
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    alignment: Alignment.topCenter,
                    child: _CategoryMegaMenuPanel(
                      products: widget.products,
                      onCategorySelected: (label) {
                        widget.onCategorySelected(label);
                        _closeMenu();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
    _controller.forward(from: 0);
    setState(() {});
  }

  void _closeMenu({bool animate = true}) {
    if (_overlayEntry == null) return;

    if (!animate) {
      _controller.stop();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
      return;
    }

    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
    });
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
  const _CategoryMegaMenuPanel({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
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
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border),
            bottom: BorderSide(color: AppColors.border),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: SizedBox(
            height: 480,
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
                            products: widget.products,
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
        child: SingleChildScrollView(
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 28,
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
  const _AllCategoryOverview({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
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
                    mainAxisExtent: 155,
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
          child: _PopularCategoryAndPickPreview(
            products: products,
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
    final columns = category.children.take(5).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in columns) ...[
                Expanded(
                  child: _MiddleCategoryColumn(
                    category: child,
                    onCategorySelected: onCategorySelected,
                  ),
                ),
                if (child != columns.last)
                  const VerticalDivider(width: 1, color: AppColors.border),
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
      borderRadius: BorderRadius.circular(12),
      onTap: () => onCategorySelected(category.label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 96,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: AppSpacing.md),
                  for (final item in category.children.take(6))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SubCategoryItem(
                        label: item.label,
                        onTap: () => onCategorySelected(item.label),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  child: _CategoryAssetImage(
                    assetPath: _categoryAssetPath(category.id),
                    height: 210,
                    scale: 1.45,
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
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _CategoryAssetImage(
                    assetPath: _categoryAssetPath(category.id),
                    scale: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
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

class _PopularCategoryAndPickPreview extends StatelessWidget {
  const _PopularCategoryAndPickPreview({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = productCategoryTree.take(5).toList(growable: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
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
                          scale: 1.25,
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
        Row(
          children: [
            Text(
              '카테고리 추천 PICK',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in _pickItems.take(4)) ...[
                Expanded(
                  child: _CategoryPickCard(
                    item: item,
                    onTap: () => onCategorySelected(item.searchLabel),
                  ),
                ),
                if (item != _pickItems.take(4).last)
                  const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<_CategoryPickItem> get _pickItems {
    if (products.isNotEmpty) {
      return [
        for (final product in products.take(4))
          _CategoryPickItem.product(product),
      ];
    }

    return const [
      _CategoryPickItem.fallback(
        title: '애플 에어팟 프로 2세대',
        categoryLabel: '디지털/가전',
        assetPath:
            'assets/images/categories/category_images/68_digital_video_audio_earphones.png',
        priceLabel: '359,000원',
        ratingLabel: '4.8',
        rtiLabel: 'RTI 91',
      ),
      _CategoryPickItem.fallback(
        title: '딥티 미스트 토너',
        categoryLabel: '뷰티',
        assetPath:
            'assets/images/categories/category_images/54_beauty_makeup_lipstick_blush.png',
        priceLabel: '28,000원',
        ratingLabel: '4.9',
        rtiLabel: 'RTI 89',
      ),
      _CategoryPickItem.fallback(
        title: '동원참치 150g 10캔',
        categoryLabel: '식품',
        assetPath:
            'assets/images/categories/category_images/69_food_processed_ramen.png',
        priceLabel: '28,000원',
        ratingLabel: '4.7',
        rtiLabel: 'RTI 90',
      ),
      _CategoryPickItem.fallback(
        title: '다이슨 V15 청소기',
        categoryLabel: '생활/주방',
        assetPath:
            'assets/images/categories/category_images/44_digital_life_appliance_air_purifier.png',
        priceLabel: '159,000원',
        ratingLabel: '4.6',
        rtiLabel: 'RTI 92',
      ),
    ];
  }
}

class _CategoryPickCard extends StatelessWidget {
  const _CategoryPickCard({required this.item, required this.onTap});

  final _CategoryPickItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.categoryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: item.usesNetworkImage
                        ? AppNetworkImage(
                            url: item.imageUrl,
                            fit: BoxFit.contain,
                            placeholderIcon: Icons.inventory_2_outlined,
                            iconSize: 26,
                          )
                        : _CategoryAssetImage(
                            assetPath: item.imageUrl,
                            scale: 1.25,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      item.ratingLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    item.rtiLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
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

class _CategoryPickItem {
  const _CategoryPickItem({
    required this.title,
    required this.categoryLabel,
    required this.imageUrl,
    required this.priceLabel,
    required this.ratingLabel,
    required this.rtiLabel,
    required this.searchLabel,
  });

  factory _CategoryPickItem.product(HomeProductData product) {
    return _CategoryPickItem(
      title: product.name,
      categoryLabel: product.label.isEmpty ? '추천' : product.label,
      imageUrl: product.imageUrl.isEmpty
          ? _fallbackAssetPathForProduct(product)
          : product.imageUrl,
      priceLabel: product.priceLabel,
      ratingLabel: product.ratingLabel,
      rtiLabel: product.rtiLabel,
      searchLabel: product.name,
    );
  }

  const factory _CategoryPickItem.fallback({
    required String title,
    required String categoryLabel,
    required String assetPath,
    required String priceLabel,
    required String ratingLabel,
    required String rtiLabel,
  }) = _FallbackCategoryPickItem;

  final String title;
  final String categoryLabel;
  final String imageUrl;
  final String priceLabel;
  final String ratingLabel;
  final String rtiLabel;
  final String searchLabel;

  bool get usesNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
}

class _FallbackCategoryPickItem extends _CategoryPickItem {
  const _FallbackCategoryPickItem({
    required super.title,
    required super.categoryLabel,
    required String assetPath,
    required super.priceLabel,
    required super.ratingLabel,
    required super.rtiLabel,
  }) : super(imageUrl: assetPath, searchLabel: title);
}

String _fallbackAssetPathForProduct(HomeProductData product) {
  final resolved = resolveProductCategory(
    product.label,
    displayName: product.label,
    productName: product.name,
  );
  return _categoryAssetPath(resolved?.id ?? '') ??
      'assets/images/categories/category_images/58_digital_mobile_tablet_camera.png';
}

class _SubCategoryItem extends StatefulWidget {
  const _SubCategoryItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_SubCategoryItem> createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<_SubCategoryItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _hovered ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            decoration: _hovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.primary,
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
    this.width,
    this.height,
    this.scale = 1,
  });

  final String? assetPath;
  final double? width;
  final double? height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null) {
      return Icon(
        Icons.category_outlined,
        color: AppColors.textTertiary,
        size: (height ?? 48) * 0.48,
      );
    }

    return Transform.scale(
      scale: scale,
      child: Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => Icon(
          Icons.category_outlined,
          color: AppColors.textTertiary,
          size: (height ?? 48) * 0.48,
        ),
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
              HeaderUserProfileButton(
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

class HeaderUserProfileButton extends StatefulWidget {
  const HeaderUserProfileButton({
    super.key,
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
  State<HeaderUserProfileButton> createState() =>
      _HeaderUserProfileButtonState();
}

class _HeaderUserProfileButtonState extends State<HeaderUserProfileButton> {
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
                      color: AppColors.primary.withValues(alpha: 0.1),
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
