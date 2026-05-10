class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.homeDashboardPath,
    required this.signupPath,
    required this.naverOAuthPath,
    required this.googleOAuthPath,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
      homeDashboardPath: String.fromEnvironment(
        'HOME_DASHBOARD_PATH',
        defaultValue: '/api/home/dashboard',
      ),
      signupPath: String.fromEnvironment('SIGNUP_PATH'),
      naverOAuthPath: String.fromEnvironment(
        'NAVER_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/naver',
      ),
      googleOAuthPath: String.fromEnvironment(
        'GOOGLE_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/google',
      ),
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    );
  }

  final String apiBaseUrl;
  final String homeDashboardPath;
  final String signupPath;
  final String naverOAuthPath;
  final String googleOAuthPath;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}
