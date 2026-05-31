import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/auth/presentation/pages/login_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/password_reset_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/signup_page.dart';
import 'package:re_view_front/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/landing/presentation/pages/landing_page.dart';
import 'package:re_view_front/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:re_view_front/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:re_view_front/features/cart/presentation/pages/cart_page.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';
import 'package:re_view_front/features/wishlist/presentation/pages/wishlist_page.dart';

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Ref ref) {
    ref.listen<bool>(isLoggedInProvider, (_, __) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthNotifier(ref);

  final router = GoRouter(
    initialLocation: RoutePaths.landing,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      const authPages = {RoutePaths.landing, RoutePaths.login, RoutePaths.signup};
      if (isLoggedIn && authPages.contains(state.matchedLocation)) {
        return RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.landing,
        name: RouteNames.landing,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const LandingPage()),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const HomePage()),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const LoginPage()),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SignupPage()),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const OnboardingPage()),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const HomeDashboardPage()),
      ),
      GoRoute(
        path: RoutePaths.search,
        name: RouteNames.search,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          SearchResultsPage(query: state.uri.queryParameters['q'] ?? ''),
        ),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        name: RouteNames.productDetail,
        pageBuilder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return _buildTransitionPage(state, ProductDetailPage(productId: id));
        },
      ),
      GoRoute(
        path: RoutePaths.oauthCallback,
        name: RouteNames.oauthCallback,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          OAuthCallbackPage(queryParams: state.uri.queryParameters),
        ),
      ),
      GoRoute(
        path: RoutePaths.passwordReset,
        name: RouteNames.passwordReset,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const PasswordResetPage()),
      ),
      GoRoute(
        path: RoutePaths.wishlist,
        name: RouteNames.wishlist,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const WishlistPage()),
      ),
      GoRoute(
        path: RoutePaths.cart,
        name: RouteNames.cart,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const CartPage()),
      ),
    ],
  );

  ref.onDispose(() {
    authNotifier.dispose();
    router.dispose();
  });

  return router;
});

CustomTransitionPage<void> _buildTransitionPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 280),
    child: child,
    transitionsBuilder: _buildTransition,
  );
}

Widget _buildTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  );

  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.04),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    ),
  );
}
