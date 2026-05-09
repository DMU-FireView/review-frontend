import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/landing/presentation/widgets/search_bar.dart'
    as landing;
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.navItems,
    required this.onLoginPressed,
    super.key,
  });

  final List<String> navItems;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
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
          child: context.isMobile
              ? _MobileHeader(onLoginPressed: onLoginPressed)
              : _DesktopHeader(
                  navItems: navItems,
                  onLoginPressed: onLoginPressed,
                ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.navItems, required this.onLoginPressed});

  final List<String> navItems;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const _BrandLogo(showMark: false),
            const SizedBox(width: AppSpacing.xxl),
            const Expanded(child: landing.SearchBar()),
            const SizedBox(width: AppSpacing.xl),
            _HeaderAction(
              icon: Icons.person_outline,
              label: '로그인',
              onTap: onLoginPressed,
            ),
            const _HeaderAction(icon: Icons.favorite_border, label: '찜'),
            const _HeaderAction(
              icon: Icons.shopping_cart_outlined,
              label: '장바구니',
              badge: '2',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final item in navItems)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xl),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: item == '홈'
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontWeight: item == '홈'
                                    ? FontWeight.w800
                                    : FontWeight.w600,
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
  const _MobileHeader({required this.onLoginPressed});

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const _BrandLogo(showMark: false),
            const Spacer(),
            IconButton(
              tooltip: '알림',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
            IconButton(
              tooltip: '장바구니',
              onPressed: () {},
              icon: const Badge(
                label: Text('2'),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const landing.SearchBar(),
      ],
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.showMark});

  final bool showMark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMark) ...[
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'R',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          'Re:view',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
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
