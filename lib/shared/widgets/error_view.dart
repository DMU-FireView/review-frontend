import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    this.title = '문제가 발생했어요',
    this.onRetry,
    this.retryLabel = '다시 시도',
    this.centered = true,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return _StatusView(
      title: title,
      message: message,
      icon: Icons.error_outline,
      iconColor: AppColors.error,
      action: onRetry == null
          ? null
          : AppButton(label: retryLabel, onPressed: onRetry),
      centered: centered,
    );
  }
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.title = '아직 표시할 내용이 없어요',
    this.action,
    this.centered = true,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return _StatusView(
      title: title,
      message: message,
      icon: Icons.inbox_outlined,
      iconColor: AppColors.textTertiary,
      action: action,
      centered: centered,
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.centered,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final bool centered;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );

    if (!centered) {
      return content;
    }

    return Center(child: content);
  }
}
