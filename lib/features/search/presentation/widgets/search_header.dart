import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
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
                    )
                  : DesktopSearchHeader(
                      query: query,
                      onSearchSubmitted: onSearchSubmitted,
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
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

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
              HeaderLink(label: '카테고리'),
              const SizedBox(width: AppSpacing.md),
              HeaderLink(label: '랭킹'),
              const SizedBox(width: AppSpacing.md),
              HeaderLink(label: '기획전'),
              const SizedBox(width: AppSpacing.md),
              HeaderLink(label: '브랜드'),
              const SizedBox(width: AppSpacing.md),
              HeaderLink(label: '리뷰 인사이트'),
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
            children: const [
              HeaderAction(icon: Icons.person_outline, label: '로그인'),
              HeaderAction(icon: Icons.favorite_border, label: '찜'),
              HeaderAction(
                icon: Icons.shopping_cart_outlined,
                label: '장바구니',
                badge: '2',
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
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: () => context.go(RoutePaths.home)),
            const Spacer(),
            IconButton(
              tooltip: '홈',
              onPressed: () => context.go(RoutePaths.home),
              icon: const Icon(Icons.home_outlined),
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
    this.badge,
  });

  final IconData icon;
  final String label;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 22, color: AppColors.textPrimary);

    return Padding(
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
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
