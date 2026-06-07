import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart'
    show HeaderUserProfileButton;
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class SearchHeader extends ConsumerWidget {
  const SearchHeader({
    super.key,
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final cartCount = ref.watch(cartItemCountProvider).value ?? 0;
    final wishlistCount = ref.watch(wishlistItemCountProvider).value ?? 0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useCompactHeader =
                context.isMobile || constraints.maxWidth < 1080;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                useCompactHeader ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xs,
                useCompactHeader ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xs,
              ),
              child: useCompactHeader
                  ? MobileSearchHeader(
                      query: query,
                      onSearchSubmitted: onSearchSubmitted,
                      isLoggedIn: isLoggedIn,
                      cartCount: cartCount,
                      onLoginPressed: () => context.go(RoutePaths.login),
                      onCartPressed: () => context.go(RoutePaths.cart),
                    )
                  : DesktopSearchHeader(
                      query: query,
                      onSearchSubmitted: onSearchSubmitted,
                      isLoggedIn: isLoggedIn,
                      nickname: nickname,
                      cartCount: cartCount,
                      wishlistCount: wishlistCount,
                      onLoginPressed: () => context.go(RoutePaths.login),
                      onWishPressed: () => context.go(RoutePaths.wishlist),
                      onCartPressed: () => context.go(RoutePaths.cart),
                      onMyPagePressed: () => context.go(
                        isLoggedIn ? RoutePaths.myPage : RoutePaths.login,
                      ),
                      onProfileWishPressed: () =>
                          context.go(RoutePaths.wishlist),
                      onProfileOrderPressed: () => context.go(RoutePaths.cart),
                      onLogoutPressed: () {
                        ref.read(authTokenStoreProvider.notifier).clear();
                        context.go(RoutePaths.home);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

class DesktopSearchHeader extends StatelessWidget {
  const DesktopSearchHeader({
    super.key,
    required this.query,
    required this.onSearchSubmitted,
    required this.isLoggedIn,
    required this.cartCount,
    required this.wishlistCount,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onMyPagePressed,
    required this.onProfileWishPressed,
    required this.onProfileOrderPressed,
    required this.onLogoutPressed,
    this.nickname,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;
  final bool isLoggedIn;
  final String? nickname;
  final int cartCount;
  final int wishlistCount;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final VoidCallback onMyPagePressed;
  final VoidCallback onProfileWishPressed;
  final VoidCallback onProfileOrderPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 440,
          child: Row(
            children: [
              HomeLogo(onTap: () => context.go(RoutePaths.home)),
              const SizedBox(width: AppSpacing.lg),
              const HeaderLink(label: '카테고리'),
              const SizedBox(width: AppSpacing.md),
              const HeaderLink(label: '랭킹'),
              const SizedBox(width: AppSpacing.md),
              const HeaderLink(label: '기획전'),
              const SizedBox(width: AppSpacing.md),
              const HeaderLink(label: '브랜드'),
              const SizedBox(width: AppSpacing.md),
              const HeaderLink(label: '리뷰 인사이트'),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 500,
              child: home.SearchBar(
                initialValue: query,
                onSubmitted: onSearchSubmitted,
                onSearchPressed: onSearchSubmitted,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 240,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isLoggedIn)
                HeaderUserProfileButton(
                  nickname: nickname,
                  onMyPagePressed: onMyPagePressed,
                  onProfileWishPressed: onProfileWishPressed,
                  onProfileOrderPressed: onProfileOrderPressed,
                  onLogoutPressed: onLogoutPressed,
                )
              else
                HeaderAction(
                  icon: Icons.person_outline,
                  label: '로그인',
                  onTap: onLoginPressed,
                ),
              HeaderAction(
                icon: Icons.favorite_border,
                label: '찜',
                onTap: onWishPressed,
                badge: wishlistCount > 0 ? '$wishlistCount' : null,
              ),
              HeaderAction(
                icon: Icons.shopping_cart_outlined,
                label: '장바구니',
                onTap: onCartPressed,
                badge: cartCount > 0 ? '$cartCount' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileSearchHeader extends StatelessWidget {
  const MobileSearchHeader({
    super.key,
    required this.query,
    required this.onSearchSubmitted,
    required this.isLoggedIn,
    required this.cartCount,
    required this.onLoginPressed,
    required this.onCartPressed,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;
  final bool isLoggedIn;
  final int cartCount;
  final VoidCallback onLoginPressed;
  final VoidCallback onCartPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: () => context.go(RoutePaths.home)),
            const Spacer(),
            IconButton(
              tooltip: isLoggedIn ? '내 계정' : '로그인',
              onPressed: onLoginPressed,
              icon: Icon(isLoggedIn ? Icons.person : Icons.person_outline),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: '장바구니',
                  onPressed: onCartPressed,
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (cartCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Badge(label: Text('$cartCount')),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        home.SearchBar(
          initialValue: query,
          onSubmitted: onSearchSubmitted,
          onSearchPressed: onSearchSubmitted,
        ),
      ],
    );
  }
}

class HeaderLink extends StatelessWidget {
  const HeaderLink({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class HeaderAction extends StatelessWidget {
  const HeaderAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.badge,
    this.active = false,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? badge;
  final bool active;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? (activeColor ?? AppColors.primary)
        : AppColors.textPrimary;
    final iconWidget = Icon(icon, size: 22, color: color);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badge == null
                ? iconWidget
                : Badge(label: Text(badge!), child: iconWidget),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
