import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({
    required this.items,
    this.onBannerPressed,
    super.key,
  });

  final List<HomeBannerData> items;
  final ValueChanged<HomeBannerData>? onBannerPressed;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late PageController _controller;
  Timer? _autoTimer;
  double _viewportFraction = 0.46;
  int _activeIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.items.length > 1 ? 1 : 0;
    _controller = PageController(
      viewportFraction: _viewportFraction,
      initialPage: _activeIndex,
    );
    _startAutoTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = context.viewportSize.width;
    final nextFraction = context.isMobile
        ? 0.88
        : (width < 900
              ? 0.82
              : (width < 1200 ? 0.68 : (width < 1600 ? 0.46 : 0.36)));
    if (nextFraction == _viewportFraction) {
      return;
    }

    _viewportFraction = nextFraction;
    _controller.dispose();
    _controller = PageController(
      viewportFraction: _viewportFraction,
      initialPage: _activeIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: context.isMobile ? 340 : (context.isTablet ? 320 : 300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _activeIndex = index),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isActive = index == _activeIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.only(
                  right: AppSpacing.md,
                  top: isActive ? 0 : AppSpacing.xs,
                  bottom: isActive ? 0 : AppSpacing.xs,
                ),
                child: _BannerCard(
                  item: item,
                  isActive: isActive,
                  onPressed: () => widget.onBannerPressed?.call(item),
                ),
              );
            },
          ),
          Positioned(
            left: context.isMobile ? AppSpacing.xs : -12,
            child: _CircleControl(
              icon: Icons.chevron_left,
              onTap: () => _moveBy(-1),
            ),
          ),
          Positioned(
            right: context.isMobile ? AppSpacing.xs : AppSpacing.lg,
            child: _CircleControl(
              icon: Icons.chevron_right,
              onTap: () => _moveBy(1),
            ),
          ),
          Positioned(
            left: context.isMobile ? AppSpacing.xl : AppSpacing.xxl,
            bottom: AppSpacing.xl,
            child: Row(
              children: [
                for (var i = 0; i < widget.items.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: i == _activeIndex ? 34 : 9,
                    height: 7,
                    margin: const EdgeInsets.only(right: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: i == _activeIndex
                          ? AppColors.textPrimary
                          : AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${_activeIndex + 1} / ${widget.items.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  tooltip: _isPaused ? '재생' : '일시정지',
                  onPressed: () => setState(() => _isPaused = !_isPaused),
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          if (!context.isMobile) ...[
            const Positioned.fill(
              child: IgnorePointer(child: _CarouselEdgeFade(isLeft: true)),
            ),
            const Positioned.fill(
              child: IgnorePointer(child: _CarouselEdgeFade(isLeft: false)),
            ),
          ],
        ],
      ),
    );
  }

  void _moveBy(int delta) {
    final next = (_activeIndex + delta) % widget.items.length;
    setState(() => _activeIndex = next);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoTimer() {
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _isPaused || widget.items.length < 2) {
        return;
      }

      _moveBy(1);
    });
  }
}

class _CarouselEdgeFade extends StatelessWidget {
  const _CarouselEdgeFade({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: const [AppColors.background, Color(0x00F8FAFC)],
          ),
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.item,
    required this.isActive,
    required this.onPressed,
  });

  final HomeBannerData item;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final useCompactText = context.viewportSize.width < 1280;

    return Semantics(
      button: true,
      label: '${item.title} ${item.emphasis}',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              if (isActive)
                const BoxShadow(
                  color: Color(0x160F172A),
                  blurRadius: 24,
                  offset: Offset(0, 16),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              item.assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => Padding(
                padding: EdgeInsets.all(context.isMobile ? AppSpacing.xl : 38),
                child: Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            item.emphasis,
                            style:
                                (context.isMobile || useCompactText
                                        ? Theme.of(
                                            context,
                                          ).textTheme.headlineSmall
                                        : Theme.of(
                                            context,
                                          ).textTheme.displayMedium)
                                    ?.copyWith(
                                      color: item.accentColor,
                                      fontWeight: FontWeight.w900,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          OutlinedButton(
                            onPressed: onPressed,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.ctaLabel),
                                const SizedBox(width: AppSpacing.xxs),
                                const Icon(Icons.chevron_right, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!context.isMobile) ...[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 8, child: _BannerVisual(item: item)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerVisual extends StatelessWidget {
  const _BannerVisual({required this.item});

  final HomeBannerData item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 172,
          height: 172,
          decoration: const BoxDecoration(
            color: Color(0xB3FFFFFF),
            shape: BoxShape.circle,
          ),
        ),
        Icon(item.icon, size: 118, color: item.accentColor.withAlpha(210)),
        Positioned(
          top: AppSpacing.sm,
          right: 0,
          child: Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              '${item.badgeLabel}\n신뢰도 확인',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: const Color(0x1A0F172A),
      child: IconButton(
        tooltip: icon == Icons.chevron_left ? '이전 배너' : '다음 배너',
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
