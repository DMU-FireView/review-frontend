import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/responsive/responsive_layout.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_hero_section.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_rti_demo_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const IgnorePointer(child: HomePage()),
        _Backdrop(onDismiss: () => context.go(RoutePaths.home)),
        _LandingCard(
          onClose: () => context.go(RoutePaths.home),
          onStartPressed: () => context.go(RoutePaths.signup),
          onRtiInfoPressed: () => context.go(RoutePaths.home),
        ),
      ],
    );
  }
}

// StatefulWidget으로 분리해야 함:
// HtmlElementView.fromTagName은 호출마다 내부 _nextId를 증가시켜 새 viewType을 생성함.
// build()에서 호출하면 리빌드마다 새 platformView가 만들어져 DOM 위치/스타일이 불안정해짐.
// initState에서 한 번만 생성하고 인스턴스를 재사용해서 안정적인 backdrop을 유지함.
class _Backdrop extends StatefulWidget {
  const _Backdrop({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  State<_Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<_Backdrop> {
  Widget? _backdropView;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _backdropView = HtmlElementView.fromTagName(
        tagName: 'div',
        onElementCreated: (Object element) {
          final el = element as dynamic;
          el.style.position = 'absolute';
          el.style.top = '0';
          el.style.left = '0';
          el.style.width = '100%';
          el.style.height = '100%';
          el.style.backgroundColor = 'rgba(15, 23, 42, 0.2)';
          el.style.backdropFilter = 'blur(2px)';
          el.style.webkitBackdropFilter = 'blur(2px)';
          el.style.pointerEvents = 'none';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            const SizedBox.expand(),
            if (_backdropView != null) _backdropView!,
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: widget.onDismiss,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(color: const Color(0x330F172A)),
      ),
    );
  }
}

class _LandingCard extends StatelessWidget {
  const _LandingCard({
    required this.onClose,
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onClose;
  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        final isMobile = screenSize == AppScreenSize.mobile;
        final viewportHeight = MediaQuery.sizeOf(context).height;

        return Center(
          child: Padding(
            padding: isMobile
                ? const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppBreakpoints.wideContentMaxWidth,
                maxHeight: viewportHeight - AppSpacing.lg * 2,
              ),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: isMobile
                          ? const EdgeInsets.all(AppSpacing.lg)
                          : const EdgeInsets.all(AppSpacing.xxl),
                      child: isMobile
                          ? _MobileContent(
                              onStartPressed: onStartPressed,
                              onRtiInfoPressed: onRtiInfoPressed,
                            )
                          : _DesktopContent(
                              onStartPressed: onStartPressed,
                              onRtiInfoPressed: onRtiInfoPressed,
                            ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: _CloseButton(onPressed: onClose),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xxl),
            child: LandingHeroSection(
              onStartPressed: onStartPressed,
              onRtiInfoPressed: onRtiInfoPressed,
            ),
          ),
        ),
        const Expanded(flex: 6, child: LandingRtiDemoCard()),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent({
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
        LandingHeroSection(
          onStartPressed: onStartPressed,
          onRtiInfoPressed: onRtiInfoPressed,
        ),
        const SizedBox(height: AppSpacing.xl),
        const LandingRtiDemoCard(),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      color: AppColors.textSecondary,
      tooltip: '홈으로',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        shape: const CircleBorder(),
      ),
    );
  }
}
