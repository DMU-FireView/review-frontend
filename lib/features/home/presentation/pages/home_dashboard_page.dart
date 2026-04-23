import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          TextButton(
            onPressed: () => context.go(RoutePaths.landing),
            child: const Text('처음으로'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.contentMaxWidth,
          ),
          child: Padding(
            padding: context.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('대시보드', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '홈 화면 콘텐츠는 다음 feature 작업에서 연결됩니다.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
