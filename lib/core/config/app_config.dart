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
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://3.39.78.175',
      ),
      homeDashboardPath: String.fromEnvironment(
        'HOME_DASHBOARD_PATH',
        defaultValue: '/api/dashboard',
      ),
      searchPath: String.fromEnvironment(
        'SEARCH_PATH',
        defaultValue: '/api/products',
      ),
      productPath: String.fromEnvironment(
        'PRODUCT_PATH',
        defaultValue: '/api/products',
      ),
      reviewFeedbackBasePath: String.fromEnvironment(
        'REVIEW_FEEDBACK_BASE_PATH',
        defaultValue: '/api/reviews',
      ),
      loginPath: String.fromEnvironment(
        'LOGIN_PATH',
        defaultValue: '/api/auth/login',
      ),
      signupPath: String.fromEnvironment(
        'SIGNUP_PATH',
        defaultValue: '/api/auth/signup',
      ),
      naverOAuthPath: String.fromEnvironment(
        'NAVER_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/naver',
      ),
      googleOAuthPath: String.fromEnvironment(
        'GOOGLE_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/google',
      ),
      passwordResetRequestPath: String.fromEnvironment(
        'PASSWORD_RESET_REQUEST_PATH',
        defaultValue: '/api/auth/password/reset-request',
      ),
      passwordResetPath: String.fromEnvironment(
        'PASSWORD_RESET_PATH',
        defaultValue: '/api/auth/password/reset',
      ),
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
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
  final Duration connectTimeout;
  final Duration receiveTimeout;
}
