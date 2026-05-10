import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.navItems,
    required this.selectedNavItem,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.searchFocusNode,
    this.cartCount,
    super.key,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final FocusNode? searchFocusNode;
  final int? cartCount;

  @override
  Widget build(BuildContext context) {
    final useCompactHeader =
        context.isMobile || context.viewportSize.width < 900;

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
                  onLoginPressed: onLoginPressed,
                  onNotificationPressed: onLoginPressed,
                  onCartPressed: onCartPressed,
                  searchFocusNode: searchFocusNode,
                )
              : _DesktopHeader(
                  navItems: navItems,
                  selectedNavItem: selectedNavItem,
                  onLoginPressed: onLoginPressed,
                  onWishPressed: onWishPressed,
                  onCartPressed: onCartPressed,
                  onNavItemPressed: onNavItemPressed,
                  searchFocusNode: searchFocusNode,
                  cartCount: cartCount,
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
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.searchFocusNode,
    this.cartCount,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final FocusNode? searchFocusNode;
  final int? cartCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const HomeLogo(),
            const SizedBox(width: AppSpacing.xxl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SizedBox(
                width: context.viewportSize.width * 0.36,
                child: home.SearchBar(focusNode: searchFocusNode),
              ),
            ),
            const Spacer(),
            const SizedBox(width: AppSpacing.xl),
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
              badge: cartCount == null || cartCount == 0 ? null : '$cartCount',
            ),
          ],
        ),
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
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({
    required this.onLoginPressed,
    required this.onNotificationPressed,
    required this.onCartPressed,
    this.searchFocusNode,
  });

  final VoidCallback onLoginPressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onCartPressed;
  final FocusNode? searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const HomeLogo(),
            const Spacer(),
            if (!context.isMobile) ...[
              TextButton(onPressed: onLoginPressed, child: const Text('로그인')),
              const SizedBox(width: AppSpacing.xs),
            ],
            IconButton(
              tooltip: '알림',
              onPressed: onNotificationPressed,
              icon: const Icon(Icons.notifications_none),
            ),
            IconButton(
              tooltip: '장바구니',
              onPressed: onCartPressed,
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        home.SearchBar(focusNode: searchFocusNode),
      ],
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
