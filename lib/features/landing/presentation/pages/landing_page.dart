import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/responsive/responsive_layout.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          builder: (context, screenSize) {
            final isMobile = screenSize == AppScreenSize.mobile;

            return AppContentView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Re:view',
                    style: isMobile
                        ? Theme.of(context).textTheme.displayMedium
                        : Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '리뷰 데이터를 더 선명하게 읽고 판단하는 서비스',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      AppButton(
                        label: '로그인',
                        onPressed: () => context.go(RoutePaths.login),
                      ),
                      AppButton(
                        label: '회원가입',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => context.go(RoutePaths.signup),
                      ),
                      AppButton(
                        label: '홈 둘러보기',
                        variant: AppButtonVariant.text,
                        onPressed: () => context.go(RoutePaths.home),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
