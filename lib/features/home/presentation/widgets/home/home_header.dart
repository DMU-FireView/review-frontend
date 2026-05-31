import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/shared/extensions/context_extensions.dart';

typedef SearchSuggestionsRequested =
    Future<List<String>> Function(String query);

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
                  wishlistCount: wishlistCount,
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
              const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '카테고리',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
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
