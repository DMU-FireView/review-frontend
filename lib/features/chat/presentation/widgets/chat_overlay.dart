import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_panel.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 앱 전체 위에 떠 있는 챗봇 런처와 패널.
///
/// `MaterialApp.router`의 builder에서 감싸므로 라우트가 바뀌어도 대화가 유지된다.
/// Navigator 바깥이라 TextField 선택 메뉴 등을 위해 자체 [Overlay]를 둔다.
class ChatOverlay extends StatefulWidget {
  const ChatOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<ChatOverlay> createState() => _ChatOverlayState();
}

class _ChatOverlayState extends State<ChatOverlay> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => const _ChatLayer(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(child: Overlay(initialEntries: [_entry])),
      ],
    );
  }
}

/// 챗봇을 숨기는 화면. 인증·온보딩 흐름과 관리자 화면에서는 띄우지 않는다.
const _hiddenPathPrefixes = [
  RoutePaths.landing,
  RoutePaths.login,
  RoutePaths.signup,
  RoutePaths.onboarding,
  RoutePaths.oauthCallback,
  RoutePaths.passwordReset,
  RoutePaths.admin,
];

final _productPathPattern = RegExp(r'^/product/(\d+)');

class _ChatLayer extends ConsumerWidget {
  const _ChatLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // redirect가 적용된 최종 위치를 써야 한다. routeInformationProvider는
    // 브라우저가 요청한 위치(예: 로그인 상태의 /landing)를 그대로 들고 있다.
    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final path = router.routerDelegate.currentConfiguration.uri.path;
        final hidden = _hiddenPathPrefixes.any(
          (prefix) => path == prefix || path.startsWith('$prefix/'),
        );
        if (hidden) return const SizedBox.shrink();

        final match = _productPathPattern.firstMatch(path);
        final productId = match == null ? null : int.tryParse(match.group(1)!);
        return _ChatLauncherLayout(
          router: router,
          productId: productId,
          // 홈 모바일은 하단 탭(72px) 위로 띄운다.
          hasBottomTabs: path == RoutePaths.home,
        );
      },
    );
  }
}

class _ChatLauncherLayout extends ConsumerWidget {
  const _ChatLauncherLayout({
    required this.router,
    required this.productId,
    required this.hasBottomTabs,
  });

  final GoRouter router;
  final int? productId;
  final bool hasBottomTabs;

  static const double _buttonSize = 56;
  static const double _bottomTabsHeight = 72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(chatViewModelProvider.select((s) => s.isOpen));
    final media = MediaQuery.of(context);
    final isMobile = AppBreakpoints.isMobile(media.size.width);
    final edge = isMobile ? AppSpacing.md : AppSpacing.lg;
    final bottom =
        media.padding.bottom +
        edge +
        (isMobile && hasBottomTabs ? _bottomTabsHeight : 0);

    final panel = ChatPanel(
      productId: productId,
      onLoginPressed: () {
        ref.read(chatViewModelProvider.notifier).close();
        router.go(RoutePaths.login);
      },
    );

    return Stack(
      children: [
        if (isOpen && isMobile)
          Positioned.fill(
            child: SafeArea(
              child: ChatPanel(
                productId: productId,
                onLoginPressed: panel.onLoginPressed,
                fullScreen: true,
              ),
            ),
          )
        else if (isOpen)
          Positioned(
            right: edge,
            bottom: bottom + _buttonSize + AppSpacing.sm,
            width: 380,
            height:
                (media.size.height - bottom - _buttonSize - 2 * AppSpacing.lg)
                    .clamp(320.0, 600.0),
            child: panel,
          ),
        if (!(isOpen && isMobile))
          Positioned(
            right: edge,
            bottom: bottom,
            child: _LauncherButton(
              isOpen: isOpen,
              onPressed: ref.read(chatViewModelProvider.notifier).toggle,
            ),
          ),
      ],
    );
  }
}

class _LauncherButton extends StatelessWidget {
  const _LauncherButton({required this.isOpen, required this.onPressed});

  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: isOpen ? l10n.chatClose : l10n.chatLauncherTooltip,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: AppColors.shadow,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: _ChatLauncherLayout._buttonSize,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween(begin: 0.85, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isOpen ? Icons.close_rounded : Icons.auto_awesome_rounded,
                key: ValueKey(isOpen),
                color: AppColors.onPrimary,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
