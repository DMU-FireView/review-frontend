import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Re:view',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '리뷰 데이터를 더 선명하게 읽고 판단하는 서비스',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () => context.go(RoutePaths.login),
                        child: const Text('로그인'),
                      ),
                      OutlinedButton(
                        onPressed: () => context.go(RoutePaths.signup),
                        child: const Text('회원가입'),
                      ),
                      TextButton(
                        onPressed: () => context.go(RoutePaths.home),
                        child: const Text('홈 둘러보기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
