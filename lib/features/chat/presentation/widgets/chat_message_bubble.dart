import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message, this.onRetry});

  final ChatMessage message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final error = message.error;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      height: 1.5,
      color: isUser ? AppColors.onPrimary : AppColors.textPrimary,
    );

    final (Color background, Color? border) = switch ((
      isUser,
      error,
      message.blocked,
    )) {
      (true, _, _) => (AppColors.primary, null),
      (_, != null, _) => (
        AppColors.errorSoft,
        AppColors.error.withValues(alpha: 0.2),
      ),
      (_, _, true) => (
        AppColors.warningSoft,
        AppColors.warning.withValues(alpha: 0.2),
      ),
      _ => (AppColors.surfaceMuted, AppColors.border),
    };

    final content = error != null
        ? _ErrorContent(kind: error, onRetry: onRetry)
        : isUser
        ? Text(message.content, style: textStyle)
        : SelectableText(message.content, style: textStyle);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: background,
            border: border == null ? null : Border.all(color: border),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadius.lg),
              topRight: const Radius.circular(AppRadius.lg),
              bottomLeft: Radius.circular(isUser ? AppRadius.lg : AppRadius.xs),
              bottomRight: Radius.circular(
                isUser ? AppRadius.xs : AppRadius.lg,
              ),
            ),
          ),
          child: message.blocked && error == null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3, right: AppSpacing.xs),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.warning,
                      ),
                    ),
                    Flexible(child: content),
                  ],
                )
              : content,
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.kind, required this.onRetry});

  final ChatErrorKind kind;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (kind) {
      ChatErrorKind.unavailable => l10n.chatErrorUnavailable,
      ChatErrorKind.timeout => l10n.chatErrorTimeout,
      ChatErrorKind.network => l10n.chatErrorNetwork,
      ChatErrorKind.unknown => l10n.chatErrorUnknown,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        ),
        if (onRetry != null)
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(l10n.chatRetry),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }
}

/// 답변을 기다리는 동안 보여 주는 말풍선.
class ChatThinkingBubble extends StatelessWidget {
  const ChatThinkingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        liveRegion: true,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadius.large,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.chatThinking,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
