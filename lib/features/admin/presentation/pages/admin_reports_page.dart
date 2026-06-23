import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_report_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_bulk_action_bar.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_filter_field.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_status_tone.dart';

class AdminReportsPage extends ConsumerWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminReportViewModelProvider);
    final vm = ref.read(adminReportViewModelProvider.notifier);

    return AdminPageScaffold(
      title: '신고 관리',
      subtitle: '사용자 신고를 검토하고 처리 상태를 변경하세요.',
      actions: [
        IconButton(
          tooltip: '새로고침',
          onPressed: vm.refresh,
          icon:
              const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
        ),
      ],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterBar(state: state, vm: vm),
                const SizedBox(height: AppSpacing.lg),
                _KpiRow(state: state),
                const SizedBox(height: AppSpacing.lg),
                _BulkBar(state: state, vm: vm),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _TableArea(state: state, vm: vm)),
              ],
            ),
          ),
          if (state.selected != null) ...[
            const SizedBox(width: AppSpacing.lg),
            ReportDetailPanel(
              report: state.selected!,
              onClose: vm.clearSelection,
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AdminDropdownField<ReportStatus?>(
          label: '상태',
          value: state.statusFilter,
          width: 180,
          items: const [
            AdminDropdownItem(value: null, label: '전체'),
            AdminDropdownItem(value: ReportStatus.pending, label: '검토 대기'),
            AdminDropdownItem(value: ReportStatus.underReview, label: '검토 중'),
            AdminDropdownItem(value: ReportStatus.accepted, label: '접수 (인정)'),
            AdminDropdownItem(value: ReportStatus.rejected, label: '기각 (미인정)'),
          ],
          onChanged: vm.selectStatus,
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.state});

  final AdminReportState state;

  @override
  Widget build(BuildContext context) {
    String valueFor(ReportStatus? s) {
      final count = state.countFor(s);
      return count == null ? '-' : formatAdminCount(count);
    }

    final cards = <Widget>[
      AdminKpiCard(
        icon: Icons.description_outlined,
        iconColor: AppColors.primary,
        label: '전체 신고',
        value: valueFor(null),
        helper: '전체 신고 건수',
      ),
      AdminKpiCard(
        icon: Icons.hourglass_empty_rounded,
        iconColor: AppColors.warning,
        label: '검토 대기',
        value: valueFor(ReportStatus.pending),
        helper: '검토가 필요한 신고',
      ),
      AdminKpiCard(
        icon: Icons.person_search_outlined,
        iconColor: AppColors.info,
        label: '검토 중',
        value: valueFor(ReportStatus.underReview),
        helper: '현재 검토 중인 신고',
      ),
      AdminKpiCard(
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.success,
        label: '접수 (인정)',
        value: valueFor(ReportStatus.accepted),
        helper: '신고가 접수된 건',
      ),
      AdminKpiCard(
        icon: Icons.cancel_outlined,
        iconColor: AppColors.error,
        label: '기각 (미인정)',
        value: valueFor(ReportStatus.rejected),
        helper: '신고가 기각된 건',
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

class _BulkBar extends StatelessWidget {
  const _BulkBar({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

  @override
  Widget build(BuildContext context) {
    final enabled = state.selectedIds.isNotEmpty && !state.isUpdating;
    return AdminBulkActionBar(
      selectedCount: state.selectedIds.length,
      actions: [
        AdminBulkActionButton(
          icon: Icons.check_circle_outline_rounded,
          label: '접수 처리',
          enabled: enabled,
          onPressed: () => vm.bulkUpdateStatus(ReportStatus.accepted),
        ),
        AdminBulkActionButton(
          icon: Icons.cancel_outlined,
          label: '기각 처리',
          enabled: enabled,
          onPressed: () => vm.bulkUpdateStatus(ReportStatus.rejected),
        ),
        AdminBulkActionButton(
          icon: Icons.person_search_outlined,
          label: '검토 중',
          enabled: enabled,
          onPressed: () => vm.bulkUpdateStatus(ReportStatus.underReview),
        ),
      ],
    );
  }
}

class _TableArea extends StatelessWidget {
  const _TableArea({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(onPressed: vm.refresh, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    const columns = [
      AdminTableColumn(label: '신고 ID', flex: 3),
      AdminTableColumn(label: '리뷰 ID', flex: 3),
      AdminTableColumn(label: '상품명', flex: 3),
      AdminTableColumn(label: '신고 사유', flex: 3),
      AdminTableColumn(label: '신고 내용', flex: 4),
      AdminTableColumn(label: 'AI 증거', flex: 2),
      AdminTableColumn(label: '상태', flex: 2),
      AdminTableColumn(label: '신고 시간', flex: 3),
    ];

    final rows = [
      for (final r in state.items)
        AdminTableRowData(
          id: r.reportId,
          cells: [
            _cell('RPT-${r.reportId}', strong: true),
            _cell('RWV-${r.reviewId}'),
            _cell(r.productName),
            _cell(r.reasonDescription.isEmpty ? r.reason : r.reasonDescription),
            _cell(r.detail),
            Align(
              alignment: Alignment.centerLeft,
              child: AdminStatusBadge(
                label: r.includeAiEvidence ? '포함' : '미포함',
                tone: r.includeAiEvidence
                    ? AdminBadgeTone.success
                    : AdminBadgeTone.neutral,
              ),
            ),
            r.status == null
                ? _cell('-')
                : Align(
                    alignment: Alignment.centerLeft,
                    child: AdminStatusBadge(
                      label: r.status!.label,
                      tone: r.status!.tone,
                    ),
                  ),
            _cell(formatAdminDateTime(r.createdAt)),
          ],
        ),
    ];

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: columns,
        rows: rows,
        selectable: true,
        selectedIds: state.selectedIds.cast<Object>(),
        onRowSelected: (id, selected) => vm.toggleRow(id as int, selected),
        onSelectAll: vm.toggleAll,
        selectedId: state.selected?.reportId,
        onRowTap: (row) {
          final item = state.items.firstWhere((r) => r.reportId == row.id);
          vm.selectItem(item);
        },
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: '표시할 신고가 없습니다.',
      ),
    );
  }

  Widget _cell(String text, {bool strong = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary,
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
