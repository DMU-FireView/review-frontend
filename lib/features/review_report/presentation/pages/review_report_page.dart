import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/providers/review_report_providers.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class ReviewReportPage extends ConsumerStatefulWidget {
  const ReviewReportPage({
    super.key,
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    this.productId,
    this.rtiScore = 0,
    this.rtiGrade = '',
  });

  final int reviewId;
  final int? productId;
  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;

  @override
  ConsumerState<ReviewReportPage> createState() => _ReviewReportPageState();
}

class _ReviewReportPageState extends ConsumerState<ReviewReportPage> {
  final _detailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Set<ReportReason> _selectedReasons = {};
  bool _includeAiEvidence = false;
  bool _agreePrivacy = false;
  bool _agreeNotFalse = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewReportViewModelProvider);

    ref.listen(reviewReportViewModelProvider, (_, next) {
      if (next is ReviewReportSuccess) {
        _showSuccessDialog();
      } else if (next is ReviewReportFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.isDuplicate ? '이미 신고한 리뷰입니다.' : next.message,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              '리뷰 신고 접수',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            actions: [
              TextButton(
                onPressed: () => context.go(RoutePaths.myPage),
                child: const Text(
                  '내 피드백 내역 보기',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1100,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: Form(
                key: _formKey,
                child: context.isMobile
                    ? _MobileLayout(
                        reviewId: widget.reviewId,
                        productId: widget.productId,
                        productName: widget.productName,
                        reviewContent: widget.reviewContent,
                        rtiScore: widget.rtiScore,
                        rtiGrade: widget.rtiGrade,
                        selectedReasons: _selectedReasons,
                        detailController: _detailController,
                        includeAiEvidence: _includeAiEvidence,
                        agreePrivacy: _agreePrivacy,
                        agreeNotFalse: _agreeNotFalse,
                        onReasonToggled: _toggleReason,
                        onIncludeAiChanged: (v) =>
                            setState(() => _includeAiEvidence = v),
                        onAgreePrivacyChanged: (v) =>
                            setState(() => _agreePrivacy = v),
                        onAgreeNotFalseChanged: (v) =>
                            setState(() => _agreeNotFalse = v),
                        onSubmit: _submit,
                        isSubmitting: state is ReviewReportSubmitting,
                      )
                    : _DesktopLayout(
                        reviewId: widget.reviewId,
                        productId: widget.productId,
                        productName: widget.productName,
                        reviewContent: widget.reviewContent,
                        rtiScore: widget.rtiScore,
                        rtiGrade: widget.rtiGrade,
                        selectedReasons: _selectedReasons,
                        detailController: _detailController,
                        includeAiEvidence: _includeAiEvidence,
                        agreePrivacy: _agreePrivacy,
                        agreeNotFalse: _agreeNotFalse,
                        onReasonToggled: _toggleReason,
                        onIncludeAiChanged: (v) =>
                            setState(() => _includeAiEvidence = v),
                        onAgreePrivacyChanged: (v) =>
                            setState(() => _agreePrivacy = v),
                        onAgreeNotFalseChanged: (v) =>
                            setState(() => _agreeNotFalse = v),
                        onSubmit: _submit,
                        isSubmitting: state is ReviewReportSubmitting,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleReason(ReportReason reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
  }

  void _submit() {
    if (_selectedReasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('신고 사유를 1개 이상 선택해주세요.')),
      );
      return;
    }
    if (!_agreePrivacy || !_agreeNotFalse) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('동의 항목을 모두 확인해주세요.')),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(reviewReportViewModelProvider.notifier).submit(
          reviewId: widget.reviewId,
          reason: _selectedReasons.first.code,
          detail: _detailController.text.trim(),
          includeAiEvidence: _includeAiEvidence,
        );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('신고 접수 완료'),
        content: const Text(
          '신고가 접수되었습니다.\n처리 결과는 피드백 내역에서 확인할 수 있어요.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RoutePaths.myPage);
            },
            child: const Text('피드백 내역 보기'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.productId != null) {
                context.goNamed(
                  RouteNames.productDetail,
                  pathParameters: {'id': widget.productId.toString()},
                );
              } else {
                context.go(RoutePaths.home);
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Desktop layout
// ─────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    required this.selectedReasons,
    required this.detailController,
    required this.includeAiEvidence,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.onReasonToggled,
    required this.onIncludeAiChanged,
    required this.onAgreePrivacyChanged,
    required this.onAgreeNotFalseChanged,
    required this.onSubmit,
    required this.isSubmitting,
    this.productId,
  });

  final int reviewId;
  final int? productId;
  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final Set<ReportReason> selectedReasons;
  final TextEditingController detailController;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ValueChanged<ReportReason> onReasonToggled;
  final ValueChanged<bool> onIncludeAiChanged;
  final ValueChanged<bool> onAgreePrivacyChanged;
  final ValueChanged<bool> onAgreeNotFalseChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 65,
          child: _MainForm(
            productName: productName,
            reviewContent: reviewContent,
            rtiScore: rtiScore,
            rtiGrade: rtiGrade,
            selectedReasons: selectedReasons,
            detailController: detailController,
            includeAiEvidence: includeAiEvidence,
            agreePrivacy: agreePrivacy,
            agreeNotFalse: agreeNotFalse,
            onReasonToggled: onReasonToggled,
            onIncludeAiChanged: onIncludeAiChanged,
            onAgreePrivacyChanged: onAgreePrivacyChanged,
            onAgreeNotFalseChanged: onAgreeNotFalseChanged,
            onSubmit: onSubmit,
            isSubmitting: isSubmitting,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        SizedBox(
          width: 280,
          child: _SidePanel(selectedCount: selectedReasons.length),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    required this.selectedReasons,
    required this.detailController,
    required this.includeAiEvidence,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.onReasonToggled,
    required this.onIncludeAiChanged,
    required this.onAgreePrivacyChanged,
    required this.onAgreeNotFalseChanged,
    required this.onSubmit,
    required this.isSubmitting,
    this.productId,
  });

  final int reviewId;
  final int? productId;
  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final Set<ReportReason> selectedReasons;
  final TextEditingController detailController;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ValueChanged<ReportReason> onReasonToggled;
  final ValueChanged<bool> onIncludeAiChanged;
  final ValueChanged<bool> onAgreePrivacyChanged;
  final ValueChanged<bool> onAgreeNotFalseChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainForm(
          productName: productName,
          reviewContent: reviewContent,
          rtiScore: rtiScore,
          rtiGrade: rtiGrade,
          selectedReasons: selectedReasons,
          detailController: detailController,
          includeAiEvidence: includeAiEvidence,
          agreePrivacy: agreePrivacy,
          agreeNotFalse: agreeNotFalse,
          onReasonToggled: onReasonToggled,
          onIncludeAiChanged: onIncludeAiChanged,
          onAgreePrivacyChanged: onAgreePrivacyChanged,
          onAgreeNotFalseChanged: onAgreeNotFalseChanged,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
        ),
        const SizedBox(height: AppSpacing.xl),
        _SidePanel(selectedCount: selectedReasons.length),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Main form
// ─────────────────────────────────────────────────────────────

class _MainForm extends StatelessWidget {
  const _MainForm({
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    required this.selectedReasons,
    required this.detailController,
    required this.includeAiEvidence,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.onReasonToggled,
    required this.onIncludeAiChanged,
    required this.onAgreePrivacyChanged,
    required this.onAgreeNotFalseChanged,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final Set<ReportReason> selectedReasons;
  final TextEditingController detailController;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ValueChanged<ReportReason> onReasonToggled;
  final ValueChanged<bool> onIncludeAiChanged;
  final ValueChanged<bool> onAgreePrivacyChanged;
  final ValueChanged<bool> onAgreeNotFalseChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepIndicator(selectedCount: selectedReasons.length),
        const SizedBox(height: AppSpacing.xl),
        _ReviewTargetCard(
          productName: productName,
          reviewContent: reviewContent,
          rtiScore: rtiScore,
          rtiGrade: rtiGrade,
        ),
        const SizedBox(height: AppSpacing.xl),
        _ReasonSection(
          selectedReasons: selectedReasons,
          onToggled: onReasonToggled,
        ),
        const SizedBox(height: AppSpacing.xl),
        _DetailSection(controller: detailController),
        const SizedBox(height: AppSpacing.xl),
        _AiEvidenceSection(
          checked: includeAiEvidence,
          onChanged: onIncludeAiChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        _AgreementSection(
          agreePrivacy: agreePrivacy,
          agreeNotFalse: agreeNotFalse,
          onPrivacyChanged: onAgreePrivacyChanged,
          onNotFalseChanged: onAgreeNotFalseChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: isSubmitting ? null : () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
              child: const Text('임시저장'),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
              child: isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('신고 접수하기'),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Step indicator
// ─────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.selectedCount});
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('대상 확인', '상품과 리뷰 정보 확인'),
      ('신고 사유', '문제 유형 선택'),
      ('상세 근거', '추가 설명 입력'),
      ('접수 완료', '검토 상태 추적'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepItem(
                number: i + 1,
                title: steps[i].$1,
                subtitle: steps[i].$2,
                isActive: i == 0,
                isDone: i == 0,
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 32,
                height: 1,
                color: AppColors.border,
              ),
          ],
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isDone,
  });

  final int number;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textTertiary;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isActive ? Colors.white : color,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Review target card
// ─────────────────────────────────────────────────────────────

class _ReviewTargetCard extends StatelessWidget {
  const _ReviewTargetCard({
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
  });

  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;

  @override
  Widget build(BuildContext context) {
    final isDanger =
        rtiGrade.toUpperCase() == 'DANGER' || rtiGrade.toUpperCase() == 'SUSPICIOUS';

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '신고 대상 리뷰',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const Spacer(),
              if (rtiScore > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: isDanger
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isDanger
                        ? '위험 리뷰 · RTI ${rtiScore.toStringAsFixed(0)}'
                        : 'RTI ${rtiScore.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDanger ? AppColors.error : AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '신고하려는 상품과 리뷰가 맞는지 확인해주세요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (reviewContent.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '"$reviewContent"',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reason section
// ─────────────────────────────────────────────────────────────

class _ReasonSection extends StatelessWidget {
  const _ReasonSection({
    required this.selectedReasons,
    required this.onToggled,
  });

  final Set<ReportReason> selectedReasons;
  final ValueChanged<ReportReason> onToggled;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '신고 사유 선택 (복수 선택 가능)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '가장 가까운 유형을 선택해주세요.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('신고 기준 보기', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // First row: 4 main reasons matching the design
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final reason in [
                ReportReason.fakeReview,
                ReportReason.aiGenerated,
                ReportReason.irrelevantContent,
                ReportReason.inappropriate,
              ])
                _ReasonCard(
                  reason: reason,
                  isSelected: selectedReasons.contains(reason),
                  onTap: () => onToggled(reason),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({
    required this.reason,
    required this.isSelected,
    required this.onTap,
  });

  final ReportReason reason;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (reason) {
        ReportReason.fakeReview => Icons.warning_amber_outlined,
        ReportReason.aiGenerated => Icons.smart_toy_outlined,
        ReportReason.irrelevantContent => Icons.link_off_outlined,
        ReportReason.inappropriate => Icons.block_outlined,
        _ => Icons.flag_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _icon,
                  size: 18,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              reason.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              reason.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Detail section
// ─────────────────────────────────────────────────────────────

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '상세 근거 입력',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '신고 판단에 도움이 되는 내용을 남겨주세요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: controller,
            maxLines: 5,
            validator: (v) {
              if (v == null || v.trim().length < 20) {
                return '최소 20자 이상 입력해주세요. (현재 ${v?.trim().length ?? 0}자)';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: '구체적인 문제 내용과 맥락을 입력해주세요.',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '최소 20자 이상 입력하면 운영팀 검토에 더 도움이 돼요.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AI Evidence section
// ─────────────────────────────────────────────────────────────

class _AiEvidenceSection extends StatelessWidget {
  const _AiEvidenceSection({
    required this.checked,
    required this.onChanged,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'AI 분석 근거 함께 제출 (선택)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '현재 리뷰의 RTI 분석 신호를 신고 근거로 첨부할 수 있어요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: checked
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: checked ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI 분석 근거 첨부',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      Text(
                        'RTI 신호 데이터가 신고 근거와 함께 제출돼요.',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Agreement section
// ─────────────────────────────────────────────────────────────

class _AgreementSection extends StatelessWidget {
  const _AgreementSection({
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.onPrivacyChanged,
    required this.onNotFalseChanged,
  });

  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ValueChanged<bool> onPrivacyChanged;
  final ValueChanged<bool> onNotFalseChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AgreementRow(
          checked: agreePrivacy,
          onChanged: onPrivacyChanged,
          label: '개인정보 수집 및 신고 처리 안내에 동의합니다.',
          sublabel:
              '신고 내용은 리뷰 접수, 처리 결과 안내, 모델 품질 개선을 위해 사용되며 필요한 기간 동안 보관됩니다.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _AgreementRow(
          checked: agreeNotFalse,
          onChanged: onNotFalseChanged,
          label: '허위 신고가 아님을 확인합니다.',
          sublabel:
              '신고 내용이 사실과 다를 경우 허위 처리 우선으로 발견될 수 있습니다.',
        ),
      ],
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.checked,
    required this.onChanged,
    required this.label,
    required this.sublabel,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: checked,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                sublabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Side panel
// ─────────────────────────────────────────────────────────────

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.selectedCount});
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SidePanelCard(
          title: '접수 요약',
          icon: Icons.summarize_outlined,
          child: Column(
            children: [
              _SummaryRow(label: '선택 사유', value: '$selectedCount개'),
              _SummaryRow(label: 'AI 근거', value: '4개'),
              _SummaryRow(label: '평균 1차 검토', value: '24h'),
              _SummaryRow(label: '대상 리뷰', value: '1건'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SidePanelCard(
          title: '처리 절차',
          icon: Icons.account_tree_outlined,
          child: Column(
            children: [
              for (final (i, step) in [
                '신고 접수',
                'AI 보조 검토',
                '운영팀 판단',
                '결과 알림',
              ].indexed)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        step,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SidePanelCard(
          title: '신고 가이드',
          icon: Icons.lightbulb_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final tip in [
                '반복 문구를 구체적으로 적기',
                '상품 사용 맥락 확인',
                '첨부 자료 첨부',
              ])
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSpacing.xxs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          tip,
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidePanelCard extends StatelessWidget {
  const _SidePanelCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared card
// ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
