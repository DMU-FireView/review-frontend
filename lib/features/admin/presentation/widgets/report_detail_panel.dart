import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_report_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_status_tone.dart';

class ReportDetailPanel extends ConsumerStatefulWidget {
  const ReportDetailPanel({
    super.key,
    required this.report,
    required this.onClose,
  });

  final AdminReport report;
  final VoidCallback onClose;

  @override
  ConsumerState<ReportDetailPanel> createState() => _ReportDetailPanelState();
}

class _ReportDetailPanelState extends ConsumerState<ReportDetailPanel> {
  late final TextEditingController _commentController;
  ReportStatus? _targetStatus;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.report.adminComment ?? '');
    _targetStatus = widget.report.status;
  }

  @override
  void didUpdateWidget(ReportDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.report.reportId != widget.report.reportId) {
      _commentController.text = widget.report.adminComment ?? '';
      _targetStatus = widget.report.status;
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
    final comment = _commentController.text.trim();
    final ok = await ref.read(adminReportViewModelProvider.notifier).updateStatus(
          reportId: widget.report.reportId,
          status: status,
          adminComment: comment.isEmpty ? null : comment,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '변경 사항이 저장되었습니다.' : '저장에 실패했습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.report;
    final isUpdating = ref.watch(
      adminReportViewModelProvider.select((s) => s.isUpdating),
    );

    return AdminDetailPanel(
      title: '신고 상세 정보',
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
            label: const Text('저장하기'),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (r.status != null)
            AdminStatusBadge(label: r.status!.label, tone: r.status!.tone),
          const SizedBox(height: AppSpacing.md),
          _Section(
            label: '신고 정보',
            child: _InfoBox(rows: [
              ('신고 ID', 'RPT-${r.reportId}'),
              ('리뷰 ID', 'RWV-${r.reviewId}'),
              ('신고 사유', r.reasonDescription.isEmpty ? r.reason : r.reasonDescription),
              ('신고 시간', formatAdminDateTime(r.createdAt)),
              ('수정 시간', formatAdminDateTime(r.updatedAt)),
            ]),
          ),
          _Section(
            label: '신고 대상 리뷰',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.productName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(r.reviewContent, style: _bodyStyle),
              ],
            ),
          ),
          _Section(
            label: '신고 내용',
            child: Text(r.detail.isEmpty ? '-' : r.detail, style: _bodyStyle),
          ),
          if (r.attachmentUrl != null && r.attachmentUrl!.isNotEmpty)
            _Section(
              label: '첨부 파일',
              child: Row(
                children: [
                  const Icon(Icons.attachment_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      r.attachmentUrl!,
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
            label: 'AI 증거 포함',
            child: AdminStatusBadge(
              label: r.includeAiEvidence ? '포함됨' : '미포함',
              tone: r.includeAiEvidence
                  ? AdminBadgeTone.success
                  : AdminBadgeTone.neutral,
            ),
          ),
          _Section(
            label: '관리자 메모',
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              style: _bodyStyle,
              decoration: InputDecoration(
                hintText: '메모를 입력하세요. (선택사항)',
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
                for (final status in ReportStatus.values)
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

  final ReportStatus status;
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
          status.label,
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
