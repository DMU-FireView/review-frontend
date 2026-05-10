import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_value_panel.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LoginValuePanel(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildLoginCard(context),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(flex: 12, child: LoginValuePanel()),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildLoginCard(context),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const LoginFooter(),
        ],
      ),
    );
  }

  LoginCard _buildLoginCard(BuildContext context) {
    return LoginCard(
      emailController: _emailController,
      passwordController: _passwordController,
      rememberMe: _rememberMe,
      obscurePassword: _obscurePassword,
      onRememberChanged: (value) => setState(() => _rememberMe = value),
      onPasswordVisibilityPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      onLoginPressed: _handleLoginPressed,
      onSignupPressed: () => context.go(RoutePaths.signup),
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

  void _handleLoginPressed() {}
}
