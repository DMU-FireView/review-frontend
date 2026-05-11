import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';

class OAuthCallbackPage extends ConsumerStatefulWidget {
  const OAuthCallbackPage({super.key, required this.queryParams});

  final Map<String, String> queryParams;

  @override
  ConsumerState<OAuthCallbackPage> createState() => _OAuthCallbackPageState();
}

class _OAuthCallbackPageState extends ConsumerState<OAuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleCallback());
  }

  void _handleCallback() {
    if (!mounted) return;

    final params = widget.queryParams;
    final error = params['error'];

    if (error != null && error.isNotEmpty) {
      context.go(RoutePaths.login);
      return;
    }

    // 백엔드가 camelCase(accessToken) 또는 snake_case(access_token) 모두 허용
    final accessToken = params['accessToken'] ?? params['access_token'];
    final tokenType =
        params['tokenType'] ?? params['token_type'] ?? 'Bearer';

    if (accessToken == null || accessToken.isEmpty) {
      context.go(RoutePaths.login);
      return;
    }

    ref.read(authTokenStoreProvider).save(
          accessToken: accessToken,
          tokenType: tokenType,
        );

    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
