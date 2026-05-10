import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/signup_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/signup_header.dart';
import 'package:re_view_front/features/auth/presentation/widgets/signup_value_panel.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _agreedToTerms = true;
  bool _agreedToMarketing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SignupHeader(
            onLogoPressed: () => context.go(RoutePaths.home),
            onLoginPressed: () => context.go(RoutePaths.login),
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
                          const _FadeUp(delay: 0, child: SignupValuePanel()),
                          const SizedBox(height: AppSpacing.xl),
                          _FadeUp(delay: 90, child: _buildSignupCard()),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: _FadeUp(delay: 0, child: SignupValuePanel()),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _FadeUp(
                                delay: 120,
                                child: _buildSignupCard(),
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

  SignupCard _buildSignupCard() {
    return SignupCard(
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      passwordConfirmController: _passwordConfirmController,
      obscurePassword: _obscurePassword,
      obscurePasswordConfirm: _obscurePasswordConfirm,
      agreedToTerms: _agreedToTerms,
      agreedToMarketing: _agreedToMarketing,
      onPasswordVisibilityPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      onPasswordConfirmVisibilityPressed: () {
        setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm);
      },
      onTermsChanged: (value) => setState(() => _agreedToTerms = value),
      onMarketingChanged: (value) => setState(() => _agreedToMarketing = value),
      onSignupPressed: _handleSignupPressed,
      onLoginPressed: () => context.go(RoutePaths.login),
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

  void _handleSignupPressed() {
    final signupPayloadPreview = {
      'nickname': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };
    debugPrint('Signup payload preview: $signupPayloadPreview');
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
