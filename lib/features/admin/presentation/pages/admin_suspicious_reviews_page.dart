import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_suspicious_review_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_filter_field.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/suspicious_review_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/trust_grade_tone.dart';

class AdminSuspiciousReviewsPage extends ConsumerWidget {
  const AdminSuspiciousReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminSuspiciousReviewViewModelProvider);
    final vm = ref.read(adminSuspiciousReviewViewModelProvider.notifier);

    return AdminPageScaffold(
      title: '의심 리뷰 관리',
      subtitle: 'RTI 분석을 통해 탐지된 의심 리뷰를 검토하고 적절한 조치를 취하세요.',
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
                _KpiRow(total: state.totalElements, isLoading: state.isLoading),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: _TableArea(state: state, vm: vm)),
              ],
            ),
          ),
          if (state.selected != null) ...[
            const SizedBox(width: AppSpacing.lg),
            SuspiciousReviewDetailPanel(
              review: state.selected!,
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

  final AdminSuspiciousReviewState state;
  final AdminSuspiciousReviewViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AdminDropdownField<int>(
          label: 'RTI 점수 상한',
          value: state.maxRti,
          width: 180,
          items: const [
            AdminDropdownItem(value: 50, label: '50점 미만'),
            AdminDropdownItem(value: 70, label: '70점 미만'),
            AdminDropdownItem(value: 85, label: '85점 미만'),
            AdminDropdownItem(value: 100, label: '전체'),
          ],
          onChanged: (v) => vm.setMaxRti(v ?? 50),
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.total, required this.isLoading});

  final int total;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 260,
          child: AdminKpiCard(
            icon: Icons.flag_outlined,
            iconColor: AppColors.warning,
            label: '전체 의심 리뷰',
            value: isLoading ? '-' : formatAdminCount(total),
            helper: '현재 조회 기준',
          ),
        ),
      ],
    );
  }
}

class _TableArea extends StatelessWidget {
  const _TableArea({required this.state, required this.vm});

  final AdminSuspiciousReviewState state;
  final AdminSuspiciousReviewViewModel vm;

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
      AdminTableColumn(label: 'RTI 점수', flex: 2),
      AdminTableColumn(label: '신뢰 등급', flex: 2),
      AdminTableColumn(label: '리뷰 내용', flex: 5),
      AdminTableColumn(label: '상품명', flex: 3),
      AdminTableColumn(label: '별점', flex: 2),
      AdminTableColumn(label: '구매 인증', flex: 2),
      AdminTableColumn(label: '작성일', flex: 3),
    ];

    final rows = [
      for (final r in state.items)
        AdminTableRowData(
          id: r.reviewId,
          cells: [
            _cell(r.rtiScore.toStringAsFixed(0), strong: true),
            r.trustGrade == null
                ? _cell('-')
                : Align(
                    alignment: Alignment.centerLeft,
                    child: AdminStatusBadge(
                      label: r.trustGrade!.label,
                      tone: r.trustGrade!.tone,
                    ),
                  ),
            _cell(r.content),
            _cell(r.productName),
            _cell('★ ${r.rating}'),
            Align(
              alignment: Alignment.centerLeft,
              child: AdminStatusBadge(
                label: r.isVerifiedPurchase ? '인증됨' : '인증 안됨',
                tone: r.isVerifiedPurchase
                    ? AdminBadgeTone.success
                    : AdminBadgeTone.neutral,
              ),
            ),
            _cell(formatAdminDate(r.writtenAt)),
          ],
        ),
    ];

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: columns,
        rows: rows,
        selectedId: state.selected?.reviewId,
        onRowTap: (row) {
          final item = state.items.firstWhere((r) => r.reviewId == row.id);
          vm.selectItem(item);
        },
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: '표시할 의심 리뷰가 없습니다.',
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
