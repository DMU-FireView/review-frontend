import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_user_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminUserViewModelProvider);
    final vm = ref.read(adminUserViewModelProvider.notifier);

    return AdminPageScaffold(
      title: l10n.adminMenuUsers,
      subtitle: '가입한 사용자를 최신 가입순으로 확인하세요.',
      actions: [
        IconButton(
          tooltip: '새로고침',
          onPressed: vm.loadList,
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.textSecondary,
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 280,
              child: AdminKpiCard(
                icon: Icons.group_outlined,
                iconColor: AppColors.primary,
                label: '전체 사용자',
                value: formatAdminCount(state.totalElements),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 목록이 있는 상태에서 다른 페이지를 못 불러오면 기존 목록 위에 알린다.
          if (state.errorMessage != null && state.items.isNotEmpty) ...[
            _ErrorBanner(message: state.errorMessage!, onRetry: vm.loadList),
            const SizedBox(height: AppSpacing.sm),
          ],
          Expanded(
            child: _UserTable(state: state, vm: vm),
          ),
        ],
      ),
    );
  }
}

class _UserTable extends StatelessWidget {
  const _UserTable({required this.state, required this.vm});

  final AdminUserState state;
  final AdminUserViewModel vm;

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
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(onPressed: vm.loadList, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: const [
          AdminTableColumn(label: 'ID', flex: 1),
          AdminTableColumn(label: '이메일', flex: 4),
          AdminTableColumn(label: '닉네임', flex: 3),
          AdminTableColumn(label: '권한', flex: 2),
          AdminTableColumn(label: '가입 경로', flex: 2),
          AdminTableColumn(label: 'ATI 점수', flex: 2),
          AdminTableColumn(label: '가입일', flex: 2),
        ],
        rows: [
          for (final user in state.items)
            AdminTableRowData(
              id: user.userId,
              cells: [
                _cell('${user.userId}'),
                _cell(user.email, strong: true),
                _cell(user.nickname.isEmpty ? '-' : user.nickname),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AdminStatusBadge(
                    label: user.isAdmin ? '관리자' : '사용자',
                    tone: user.isAdmin
                        ? AdminBadgeTone.info
                        : AdminBadgeTone.neutral,
                  ),
                ),
                _cell(_providerLabel(user)),
                _cell(user.atiScore?.toStringAsFixed(1) ?? '-'),
                _cell(formatAdminDate(user.createdAt)),
              ],
            ),
        ],
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: '가입한 사용자가 없습니다.',
      ),
    );
  }

  String _providerLabel(AdminUser user) {
    return switch (user.provider?.toUpperCase()) {
      'GOOGLE' => 'Google',
      'NAVER' => '네이버',
      null || '' || 'LOCAL' => '이메일',
      final other => other,
    };
  }

  Widget _cell(String text, {bool strong = false}) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.error),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
