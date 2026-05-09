import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/landing/presentation/data/home_landing_content.dart';
import 'package:re_view_front/features/landing/presentation/widgets/benefit_cta.dart';
import 'package:re_view_front/features/landing/presentation/widgets/hero_banner_carousel.dart';
import 'package:re_view_front/features/landing/presentation/widgets/home_footer.dart';
import 'package:re_view_front/features/landing/presentation/widgets/home_header.dart';
import 'package:re_view_front/features/landing/presentation/widgets/popular_category_section.dart';
import 'package:re_view_front/features/landing/presentation/widgets/product_recommendation_section.dart';
import 'package:re_view_front/features/landing/presentation/widgets/quick_category_row.dart';
import 'package:re_view_front/features/landing/presentation/widgets/review_trust_info_card.dart';
import 'package:re_view_front/features/landing/presentation/widgets/trending_keyword_chips.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final useWideCommerceGrid = context.viewportSize.width >= 1180;
    final page = Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              onLoginPressed: () => context.go(RoutePaths.login),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FadeUp(delay: 0, child: HeroBannerCarousel(items: banners)),
                  const SizedBox(height: AppSpacing.lg),
                  const _FadeUp(
                    delay: 60,
                    child: QuickCategoryRow(items: quickCategories),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FadeUp(
                    delay: 120,
                    child: TrendingKeywordChips(keywords: trendingKeywords),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (useWideCommerceGrid)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 14,
                          child: _FadeUp(
                            delay: 180,
                            child: ProductRecommendationSection(
                              products: recommendedProducts,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              const _FadeUp(
                                delay: 240,
                                child: ReviewTrustInfoCard(),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              _FadeUp(
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
                    )
                  else ...[
                    const _FadeUp(
                      delay: 180,
                      child: ProductRecommendationSection(
                        products: recommendedProducts,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _FadeUp(delay: 240, child: ReviewTrustInfoCard()),
                    const SizedBox(height: AppSpacing.xl),
                    _FadeUp(
                      delay: 300,
                      child: BenefitCTA(
                        items: benefitItems,
                        onBenefitPressed: () => context.go(RoutePaths.login),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  const _FadeUp(
                    delay: 360,
                    child: PopularCategorySection(items: popularCategories),
                  ),
                  SizedBox(height: context.isMobile ? 96 : AppSpacing.xxxl),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: HomeFooter()),
        ],
      ),
      bottomNavigationBar: context.isMobile ? const _HomeBottomTabs() : null,
    );

    return page;
  }
}

class _FadeUp extends StatefulWidget {
  const _FadeUp({required this.child, required this.delay});

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

class _HomeBottomTabs extends StatelessWidget {
  const _HomeBottomTabs();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_filled, '홈'),
      (Icons.grid_view_outlined, '카테고리'),
      (Icons.search, '검색'),
      (Icons.favorite_border, '찜'),
      (Icons.person_outline, '마이'),
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
          for (final item in items)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.$1,
                    color: item.$2 == '홈'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    size: 27,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.$2,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: item.$2 == '홈'
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: item.$2 == '홈'
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
