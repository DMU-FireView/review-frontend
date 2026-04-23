import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          AppButton(
            variant: AppButtonVariant.text,
            onPressed: () => context.go(RoutePaths.landing),
            label: '처음으로',
          ),
        ],
      ),
      body: const AppContentView(
        maxWidth: AppBreakpoints.contentMaxWidth,
        child: AppEmptyView(
          title: '대시보드 준비 중',
          message: '홈 화면 콘텐츠는 다음 feature 작업에서 연결됩니다.',
        ),
      ),
    );
  }
}
