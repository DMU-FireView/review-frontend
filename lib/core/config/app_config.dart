class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.homeDashboardPath,
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
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    );
  }

  final String apiBaseUrl;
  final String homeDashboardPath;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}
