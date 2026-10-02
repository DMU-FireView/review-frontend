import 'package:re_view_front/app/router/route_paths.dart';

/// 서버가 내려주는 알림 이동 경로를 앱 라우트로 바꾼다. 모르는 경로면 null.
///
/// 서버 기준: /products/{id}, /reports/me/{id}, /feedback/me/{id}
String? notificationRoute(String? targetUrl) {
  if (targetUrl == null) return null;
  final path = Uri.tryParse(targetUrl)?.path ?? targetUrl;

  final product = RegExp(r'^/products?/(\d+)').firstMatch(path);
  if (product != null) return '/product/${product.group(1)}';

  if (path.startsWith('/reports/me') || path.startsWith('/feedback/me')) {
    return RoutePaths.feedbackHistory;
  }
  return null;
}
