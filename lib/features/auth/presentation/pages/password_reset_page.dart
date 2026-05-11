import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset_value_panel.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({super.key});

  @override
  ConsumerState<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _newPasswordController.addListener(_onNewPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _newPasswordController.removeListener(_onNewPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    ref
        .read(passwordResetViewModelProvider.notifier)
        .emailChanged(_emailController.text);
  }

  void _onNewPasswordChanged() {
    ref
        .read(passwordResetViewModelProvider.notifier)
        .newPasswordChanged(_newPasswordController.text);
  }

  void _onConfirmPasswordChanged() {
    ref
        .read(passwordResetViewModelProvider.notifier)
        .confirmPasswordChanged(_confirmPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            navItems: homeNavItems,
            selectedNavItem: '홈',
            onLoginPressed: () => context.go(RoutePaths.login),
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
                child: context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _FadeUp(
                            delay: 0,
                            child: PasswordResetValuePanel(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _FadeUp(delay: 90, child: _buildCard(state)),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: _FadeUp(
                              delay: 0,
                              child: PasswordResetValuePanel(),
                            ),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _FadeUp(
                                delay: 120,
                                child: _buildCard(state),
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

  PasswordResetCard _buildCard(PasswordResetState state) {
    return PasswordResetCard(
      state: state,
      emailController: _emailController,
      newPasswordController: _newPasswordController,
      confirmPasswordController: _confirmPasswordController,
      obscureNewPassword: _obscureNewPassword,
      obscureConfirmPassword: _obscureConfirmPassword,
      onSendCode: state.isLoading
          ? null
          : () => ref
              .read(passwordResetViewModelProvider.notifier)
              .sendVerificationCode(),
      onProceed: state.isLoading
          ? null
          : () => ref
              .read(passwordResetViewModelProvider.notifier)
              .proceedToNewPassword(),
      onResetPassword: state.isLoading
          ? null
          : () =>
              ref.read(passwordResetViewModelProvider.notifier).resetPassword(),
      onResendCode: () =>
          ref.read(passwordResetViewModelProvider.notifier).resendCode(),
      onToggleNewPasswordVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      onToggleConfirmPasswordVisibility: () =>
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
      onLoginPressed: () => context.go(RoutePaths.login),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    if (context.isMobile) return const EdgeInsets.fromLTRB(16, 28, 16, 48);
    if (context.isTablet) return const EdgeInsets.fromLTRB(24, 48, 24, 64);
    return const EdgeInsets.fromLTRB(32, 56, 32, 48);
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
    _opacity =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future<void>.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
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
