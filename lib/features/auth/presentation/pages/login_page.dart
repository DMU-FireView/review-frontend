import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/platform/external_redirect.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_value_panel.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_handlePasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_handleEmailChanged);
    _passwordController.removeListener(_handlePasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.status == LoginSubmissionStatus.success) {
        context.go(
          next.onboardingCompleted
              ? RoutePaths.home
              : RoutePaths.onboarding,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            navItems: homeNavItems,
            selectedNavItem: '홈',
            onLoginPressed: () {},
            onWishPressed: () => context.go(RoutePaths.home),
            onCartPressed: () => context.go(RoutePaths.home),
            onNavItemPressed: (_) => context.go(RoutePaths.home),
            onLogoPressed: () => context.go(RoutePaths.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AppContentView(
                maxWidth: 1360,
                padding: _pagePadding(context),
                child: !context.isDesktop
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _FadeUp(delay: 0, child: LoginValuePanel()),
                          const SizedBox(height: AppSpacing.xl),
                          _FadeUp(
                            delay: 90,
                            child: _buildLoginCard(context, loginState),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: _FadeUp(delay: 0, child: LoginValuePanel()),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _FadeUp(
                                delay: 120,
                                child: _buildLoginCard(context, loginState),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const _FadeUp(delay: 220, child: LoginFooter()),
        ],
      ),
    );
  }

  LoginCard _buildLoginCard(BuildContext context, LoginState loginState) {
    return LoginCard(
      emailController: _emailController,
      passwordController: _passwordController,
      rememberMe: loginState.rememberMe,
      obscurePassword: _obscurePassword,
      emailError: loginState.emailError,
      passwordError: loginState.passwordError,
      failureMessage: loginState.failureMessage,
      isLoading: loginState.isLoading,
      onRememberChanged: (value) {
        ref.read(loginViewModelProvider.notifier).rememberMeChanged(value);
      },
      onPasswordVisibilityPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      onLoginPressed: loginState.isLoading ? null : _handleLoginPressed,
      onOAuthPressed: loginState.isLoading ? null : _handleOAuthPressed,
      onSignupPressed: () => context.go(RoutePaths.signup),
      onForgotPasswordPressed: () => context.go(RoutePaths.passwordReset),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    if (context.isMobile) {
      return const EdgeInsets.fromLTRB(16, 28, 16, 48);
    }

    if (context.isTablet) {
      return const EdgeInsets.fromLTRB(24, 48, 24, 64);
    }

    return const EdgeInsets.fromLTRB(32, 56, 32, 48);
  }

  void _handleEmailChanged() {
    ref
        .read(loginViewModelProvider.notifier)
        .emailChanged(_emailController.text);
  }

  void _handlePasswordChanged() {
    ref
        .read(loginViewModelProvider.notifier)
        .passwordChanged(_passwordController.text);
  }

  void _handleLoginPressed() {
    ref.read(loginViewModelProvider.notifier).submit();
  }

  Future<void> _handleOAuthPressed(OAuthProvider provider) async {
    final uri = await ref
        .read(loginViewModelProvider.notifier)
        .startOAuth(provider);
    if (uri == null) {
      return;
    }

    redirectToExternalUrl(uri);
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

    Future<void>.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
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
