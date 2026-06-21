import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_analysis_feedback_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/analysis_feedback_status_tone.dart';

class AnalysisFeedbackDetailPanel extends ConsumerStatefulWidget {
  const AnalysisFeedbackDetailPanel({
    super.key,
    required this.feedback,
    required this.onClose,
  });

  final AdminAnalysisFeedback feedback;
  final VoidCallback onClose;

  @override
  ConsumerState<AnalysisFeedbackDetailPanel> createState() =>
      _AnalysisFeedbackDetailPanelState();
}

class _AnalysisFeedbackDetailPanelState
    extends ConsumerState<AnalysisFeedbackDetailPanel> {
  late final TextEditingController _commentController;
  AnalysisFeedbackStatus? _targetStatus;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _targetStatus = widget.feedback.status;
  }

  @override
  void didUpdateWidget(AnalysisFeedbackDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feedback.feedbackId != widget.feedback.feedbackId) {
      _commentController.clear();
      _targetStatus = widget.feedback.status;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final status = _targetStatus;
    if (status == null) return;
    final ok = await ref
        .read(adminAnalysisFeedbackViewModelProvider.notifier)
        .updateStatus(
          feedbackId: widget.feedback.feedbackId,
          status: status,
          adminComment: _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '변경 사항이 저장되었습니다.' : '저장에 실패했습니다.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feedback;
    final isUpdating = ref.watch(
      adminAnalysisFeedbackViewModelProvider.select((s) => s.isUpdating),
    );

    return AdminDetailPanel(
      title: '피드백 상세 정보',
      onClose: widget.onClose,
      actions: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isUpdating ? null : _save,
            icon: isUpdating
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: const Text('변경 사항 저장'),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (f.status != null)
            AdminStatusBadge(label: f.status!.label, tone: f.status!.tone),
          const SizedBox(height: AppSpacing.md),
          _InfoBox(rows: [
            ('피드백 ID', 'FB-${f.feedbackId}'),
            ('리뷰 ID', 'RWV-${f.reviewId}'),
            ('상품명', f.productName),
            ('등록일', formatAdminDateTime(f.createdAt)),
            ('수정일', formatAdminDateTime(f.updatedAt)),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            label: '피드백 유형',
            child: Text(
              f.feedbackTypeDescription.isEmpty
                  ? f.feedbackType
                  : f.feedbackTypeDescription,
              style: _bodyStyle,
            ),
          ),
          _Section(
            label: '사용자 판단',
            child: AdminStatusBadge(
              label: f.userJudgmentLabel,
              tone: AdminBadgeTone.neutral,
            ),
          ),
          if (f.relatedSignals.isNotEmpty)
            _Section(
              label: '관련 신호 (${f.relatedSignals.length})',
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final signal in f.relatedSignals)
                    AdminStatusBadge(label: signal, tone: AdminBadgeTone.info),
                ],
              ),
            ),
          _Section(
            label: '피드백 내용',
            child: Text(
              f.detail?.isNotEmpty == true ? f.detail! : '-',
              style: _bodyStyle,
            ),
          ),
          if (f.attachmentUrl != null && f.attachmentUrl!.isNotEmpty)
            _Section(
              label: '첨부 파일 / 링크',
              child: Row(
                children: [
                  const Icon(Icons.attachment_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      f.attachmentUrl!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          _Section(
            label: '회신 이메일',
            child: Text(
              f.replyEmail?.isNotEmpty == true ? f.replyEmail! : '-',
              style: _bodyStyle,
            ),
          ),
          _Section(
            label: '관리자 메모',
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 1000,
              style: _bodyStyle,
              decoration: InputDecoration(
                hintText: '검토 내용이나 조치 사항을 입력하세요...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          _Section(
            label: '상태 변경',
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final status in AnalysisFeedbackStatus.values)
                  _StatusChoice(
                    status: status,
                    selected: _targetStatus == status,
                    onTap: () => setState(() => _targetStatus = status),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _bodyStyle = TextStyle(
  fontSize: 13,
  color: AppColors.textPrimary,
  height: 1.5,
);

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    rows[i].$1,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChoice extends StatelessWidget {
  const _StatusChoice({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final AnalysisFeedbackStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status.tone) {
      AdminBadgeTone.info => (AppColors.primaryLight, AppColors.primary),
      AdminBadgeTone.success => (AppColors.successSoft, AppColors.success),
      AdminBadgeTone.warning => (AppColors.warningSoft, AppColors.warning),
      AdminBadgeTone.danger => (AppColors.errorSoft, AppColors.error),
      AdminBadgeTone.neutral => (AppColors.surfaceMuted, AppColors.textSecondary),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? bg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: selected ? fg : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          status.code,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? fg : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
