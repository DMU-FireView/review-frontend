import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.homeDashboardPath,
    required this.searchPath,
    required this.productPath,
    required this.reviewFeedbackBasePath,
    required this.loginPath,
    required this.signupPath,
    required this.naverOAuthPath,
    required this.googleOAuthPath,
    required this.passwordResetRequestPath,
    required this.passwordResetPath,
    required this.userMePath,
    required this.landingStatsPath,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment() {
    const explicitBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    // On web, use the current origin so Vercel proxy rewrites handle API routing.
    // Explicit dart-define overrides this for local web dev against a real server.
    final apiBaseUrl = explicitBaseUrl.isNotEmpty
        ? explicitBaseUrl
        : (kIsWeb ? Uri.base.origin : 'https://api.beens.kr');

    return AppConfig(
      apiBaseUrl: apiBaseUrl,
      homeDashboardPath: const String.fromEnvironment(
        'HOME_DASHBOARD_PATH',
        defaultValue: '/api/dashboard',
      ),
      searchPath: const String.fromEnvironment(
        'SEARCH_PATH',
        defaultValue: '/api/products',
      ),
      productPath: const String.fromEnvironment(
        'PRODUCT_PATH',
        defaultValue: '/api/products',
      ),
      reviewFeedbackBasePath: const String.fromEnvironment(
        'REVIEW_FEEDBACK_BASE_PATH',
        defaultValue: '/api/reviews',
      ),
      loginPath: const String.fromEnvironment(
        'LOGIN_PATH',
        defaultValue: '/api/auth/login',
      ),
      signupPath: const String.fromEnvironment(
        'SIGNUP_PATH',
        defaultValue: '/api/auth/signup',
      ),
      naverOAuthPath: const String.fromEnvironment(
        'NAVER_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/naver',
      ),
      googleOAuthPath: const String.fromEnvironment(
        'GOOGLE_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/google',
      ),
      passwordResetRequestPath: const String.fromEnvironment(
        'PASSWORD_RESET_REQUEST_PATH',
        defaultValue: '/api/auth/password/reset-request',
      ),
      passwordResetPath: const String.fromEnvironment(
        'PASSWORD_RESET_PATH',
        defaultValue: '/api/auth/password/reset',
      ),
      userMePath: const String.fromEnvironment(
        'USER_ME_PATH',
        defaultValue: '/api/users/me',
      ),
      landingStatsPath: const String.fromEnvironment(
        'LANDING_STATS_PATH',
        defaultValue: '/api/landing/stats',
      ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  final String apiBaseUrl;
  final String homeDashboardPath;
  final String searchPath;
  final String productPath;
  final String reviewFeedbackBasePath;
  final String loginPath;
  final String signupPath;
  final String naverOAuthPath;
  final String googleOAuthPath;
  final String passwordResetRequestPath;
  final String passwordResetPath;
  final String userMePath;
  final String landingStatsPath;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}
