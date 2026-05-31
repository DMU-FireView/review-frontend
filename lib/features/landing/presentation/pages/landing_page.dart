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

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // HtmlElementView 이미지들은 Flutter 캔버스 위 HTML 레이어에 렌더링되므로
      // BackdropFilter가 적용되지 않음. 동일한 HTML 레이어에 div를 올려 시각적으로 덮음.
      // pointer-events: none 으로 터치 이벤트는 아래 GestureDetector로 통과시킴.
      return GestureDetector(
        onTap: onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            HtmlElementView.fromTagName(
              tagName: 'div',
              onElementCreated: (Object element) {
                final el = element as dynamic;
                // position: absolute + viewport 단위로 뷰포트 전체 커버
                // fixed는 CanvasKit의 transform 컨텍스트에서 동작하지 않음
                el.style.position = 'absolute';
                el.style.top = '0';
                el.style.left = '0';
                el.style.width = '100vw';
                el.style.height = '100vh';
                el.style.backgroundColor = 'rgba(15, 23, 42, 0.2)';
                el.style.backdropFilter = 'blur(2px)';
                el.style.webkitBackdropFilter = 'blur(2px)';
                el.style.pointerEvents = 'none';
              },
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onDismiss,
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
