import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/responsive/responsive_layout.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_hero_section.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_rti_demo_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveLayout(
          builder: (context, screenSize) {
            final isDesktop = screenSize == AppScreenSize.desktop;
            final isTablet = screenSize == AppScreenSize.tablet;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: isDesktop
                      ? const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxxl,
                          vertical: AppSpacing.xxl,
                        )
                      : isTablet
                      ? const EdgeInsets.all(AppSpacing.xl)
                      : const EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppBreakpoints.wideContentMaxWidth,
                      ),
                      child: isDesktop || isTablet
                          ? _DesktopLayout(
                              onStartPressed: () =>
                                  context.go(RoutePaths.signup),
                              onRtiInfoPressed: () =>
                                  context.go(RoutePaths.home),
                            )
                          : _MobileLayout(
                              onStartPressed: () =>
                                  context.go(RoutePaths.signup),
                              onRtiInfoPressed: () =>
                                  context.go(RoutePaths.home),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: _HomeLink(onPressed: () => context.go(RoutePaths.home)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: LandingHeroSection(
                onStartPressed: onStartPressed,
                onRtiInfoPressed: onRtiInfoPressed,
              ),
            ),
            const SizedBox(width: AppSpacing.xxl),
            const Expanded(flex: 6, child: LandingRtiDemoCard()),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        LandingHeroSection(
          onStartPressed: onStartPressed,
          onRtiInfoPressed: onRtiInfoPressed,
        ),
        const SizedBox(height: AppSpacing.xl),
        const LandingRtiDemoCard(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _HomeLink extends StatelessWidget {
  const _HomeLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.close, size: 16),
      label: Text(
        '홈으로',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
      ),
    );
  }
}
