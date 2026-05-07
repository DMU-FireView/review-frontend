import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.authMaxWidth,
          ),
          child: Padding(
            padding: context.pagePadding.copyWith(
              left: context.isMobile ? AppSpacing.md : AppSpacing.lg,
              right: context.isMobile ? AppSpacing.md : AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '새 계정 만들기',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  '회원가입 화면은 다음 feature 작업에서 연결됩니다.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  isExpanded: true,
                  label: '홈으로 이동',
                  onPressed: () => context.go(RoutePaths.home),
                ),
                AppButton(
                  isExpanded: true,
                  label: '로그인하기',
                  variant: AppButtonVariant.text,
                  onPressed: () => context.go(RoutePaths.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
