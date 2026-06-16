import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = !AppBreakpoints.isMobile(width) &&
        !AppBreakpoints.isTablet(width);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final items = _AdminMenuItem.all(AppLocalizations.of(context));

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AdminSidebar(
              items: items,
              currentLocation: currentLocation,
              onLogout: () => _logout(context, ref),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context).adminSidebarTitle),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        child: SafeArea(
          child: _AdminSidebar(
            items: items,
            currentLocation: currentLocation,
            onLogout: () => _logout(context, ref),
            inDrawer: true,
          ),
        ),
      ),
      body: child,
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(logoutUseCaseProvider).call();
    if (context.mounted) {
      context.go(RoutePaths.landing);
    }
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({
    required this.items,
    required this.currentLocation,
    required this.onLogout,
    this.inDrawer = false,
  });

  final List<_AdminMenuItem> items;
  final String currentLocation;
  final VoidCallback onLogout;
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: inDrawer ? null : 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: inDrawer
            ? null
            : const Border(
                right: BorderSide(color: AppColors.border),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!inDrawer)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Text(
                AppLocalizations.of(context).adminSidebarTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              children: [
                for (final item in items)
                  _AdminMenuTile(
                    item: item,
                    isActive: _isActive(item.path, currentLocation),
                    onTap: () {
                      if (inDrawer) {
                        Navigator.of(context).pop();
                      }
                      context.go(item.path);
                    },
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: _AdminMenuTile(
              item: _AdminMenuItem(
                path: '',
                label: AppLocalizations.of(context).adminMenuLogout,
                icon: Icons.logout_rounded,
              ),
              isActive: false,
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }

  bool _isActive(String path, String current) {
    if (path == RoutePaths.admin) {
      return current == RoutePaths.admin;
    }
    return current == path || current.startsWith('$path/');
  }
}

class _AdminMenuTile extends StatelessWidget {
  const _AdminMenuTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _AdminMenuItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Material(
        color: isActive ? AppColors.primaryLight : Colors.transparent,
        borderRadius: AppRadius.medium,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.medium,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textPrimary,
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

class _AdminMenuItem {
  const _AdminMenuItem({
    required this.path,
    required this.label,
    required this.icon,
  });

  final String path;
  final String label;
  final IconData icon;

  static List<_AdminMenuItem> all(AppLocalizations l10n) => [
        _AdminMenuItem(
          path: RoutePaths.admin,
          label: l10n.adminMenuDashboard,
          icon: Icons.dashboard_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminReviews,
          label: l10n.adminMenuSuspiciousReviews,
          icon: Icons.rate_review_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminReports,
          label: l10n.adminMenuReports,
          icon: Icons.flag_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminAnalysisFeedbacks,
          label: l10n.adminMenuAnalysisFeedbacks,
          icon: Icons.fact_check_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminUsers,
          label: l10n.adminMenuUsers,
          icon: Icons.people_outline,
        ),
      ];
}
