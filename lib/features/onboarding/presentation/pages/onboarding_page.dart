import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';

/// 온보딩 페이지 (feat/onboarding에서 구현 예정)
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('관심 카테고리를 선택해주세요', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '온보딩 화면은 준비 중입니다.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.go(RoutePaths.dashboard),
              child: const Text('홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
