import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 서버 `TopicGuard.MAX_QUESTION_LENGTH`와 같은 값.
const _maxQuestionLength = 500;

class ChatPanel extends ConsumerWidget {
  const ChatPanel({
    super.key,
    required this.productId,
    required this.onLoginPressed,
  });

  /// 현재 화면의 상품. 상품 상세가 아니면 null.
  final int? productId;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final state = ref.watch(chatViewModelProvider);
    final vm = ref.read(chatViewModelProvider.notifier);

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      label: AppLocalizations.of(context).chatTitle,
      child: CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.escape): vm.close},
        child: FocusScope(
          autofocus: true,
          child: Material(
            color: AppColors.surface,
            elevation: 12,
            shadowColor: AppColors.shadow,
            borderRadius: AppRadius.large,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _Header(
                  canStartNew: isLoggedIn && state.hasConversation,
                  onNew: () => vm.startNew(productId: productId),
                  onClose: vm.close,
                ),
                const Divider(height: 1, color: AppColors.border),
                if (isLoggedIn) ...[
                  _ContextBar(state: state, productId: productId),
                  Expanded(
                    child: state.hasConversation
                        ? _MessageList(state: state, productId: productId)
                        : _EmptyState(productId: productId),
                  ),
                  _Composer(
                    isSending: state.isSending,
                    onSend: (text) => vm.send(text, productId: productId),
                  ),
                ] else
                  Expanded(child: _LoginPrompt(onLoginPressed: onLoginPressed)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.canStartNew,
    required this.onNew,
    required this.onClose,
  });

  final bool canStartNew;
  final VoidCallback onNew;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatTitle,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l10n.chatSubtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (canStartNew)
            IconButton(
              tooltip: l10n.chatNewConversation,
              onPressed: onNew,
              icon: const Icon(Icons.add_comment_outlined, size: 20),
              color: AppColors.textSecondary,
            ),
          IconButton(
            tooltip: l10n.chatClose,
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// 상품 상세에서 열었을 때 대화 기준 상품을 알려 준다.
class _ContextBar extends ConsumerWidget {
  const _ContextBar({required this.state, required this.productId});

  final ChatState state;
  final int? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = this.productId;
    if (productId == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final isOtherProduct =
        state.sessionId != null && state.sessionProductId != productId;

    return Container(
      width: double.infinity,
      color: isOtherProduct ? AppColors.warningSoft : AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            isOtherProduct
                ? Icons.info_outline_rounded
                : Icons.inventory_2_outlined,
            size: 16,
            color: isOtherProduct ? AppColors.warning : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              isOtherProduct
                  ? l10n.chatOtherProductNotice
                  : l10n.chatProductContext,
              style: textStyle?.copyWith(color: AppColors.textPrimary),
            ),
          ),
          if (isOtherProduct)
            TextButton(
              onPressed: state.isSending
                  ? null
                  : () => ref
                        .read(chatViewModelProvider.notifier)
                        .startNew(productId: productId),
              child: Text(l10n.chatStartWithThisProduct),
            ),
        ],
      ),
    );
  }
}

class _MessageList extends ConsumerWidget {
  const _MessageList({required this.state, required this.productId});

  final ChatState state;
  final int? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = state.messages;
    final extra = state.isSending ? 1 : 0;
    // reverse로 그려서 새 메시지가 오면 항상 맨 아래가 보이게 한다.
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: messages.length + extra,
      itemBuilder: (context, index) {
        if (state.isSending && index == 0) {
          return const ChatThinkingBubble();
        }
        final message = messages[messages.length - 1 - (index - extra)];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ChatMessageBubble(
            message: message,
            onRetry: message.error == null
                ? null
                : () => ref
                      .read(chatViewModelProvider.notifier)
                      .retry(productId: productId),
          ),
        );
      },
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final suggestions = productId != null
        ? [
            l10n.chatSuggestProduct1,
            l10n.chatSuggestProduct2,
            l10n.chatSuggestProduct3,
          ]
        : [l10n.chatSuggestGeneral1, l10n.chatSuggestGeneral2];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          l10n.chatEmptyTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.chatEmptyBody,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final suggestion in suggestions)
              ActionChip(
                label: Text(suggestion),
                labelStyle: textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColors.primaryLight,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                onPressed: () => ref
                    .read(chatViewModelProvider.notifier)
                    .send(suggestion, productId: productId),
              ),
          ],
        ),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLoginPressed});

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 40,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.chatLoginTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.chatLoginBody,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: onLoginPressed,
            child: Text(l10n.chatLoginButton),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatefulWidget {
  const _Composer({required this.isSending, required this.onSend});

  final bool isSending;
  final ValueChanged<String> onSend;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: _maxQuestionLength,
                  // multiline이 아니면 여러 줄 입력창에서도 Enter가 전송으로 동작한다.
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: l10n.chatInputHint,
                    counterText: '',
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.surfaceMuted,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  final canSend =
                      !widget.isSending && _controller.text.trim().isNotEmpty;
                  return IconButton.filled(
                    tooltip: l10n.chatSend,
                    onPressed: canSend ? _submit : null,
                    icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.chatDisclaimer,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
