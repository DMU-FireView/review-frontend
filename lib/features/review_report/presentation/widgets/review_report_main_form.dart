import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/agreement_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/ai_evidence_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/detail_input_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/reason_selector_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/report_action_buttons.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_step_indicator.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_target_card.dart';

class ReviewReportMainForm extends StatelessWidget {
  const ReviewReportMainForm({
    super.key,
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    required this.selectedReasons,
    required this.detailController,
    required this.reportType,
    required this.disclosure,
    required this.includeAiEvidence,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.currentStep,
    required this.onReasonToggled,
    required this.onReportTypeChanged,
    required this.onDisclosureChanged,
    required this.onIncludeAiChanged,
    required this.onAgreePrivacyChanged,
    required this.onAgreeNotFalseChanged,
    required this.onSubmit,
    required this.isSubmitting,
    this.onSaveDraft,
  });

  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final Set<ReportReason> selectedReasons;
  final TextEditingController detailController;
  final String? reportType;
  final String? disclosure;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ReportStep currentStep;
  final ValueChanged<ReportReason> onReasonToggled;
  final ValueChanged<String?> onReportTypeChanged;
  final ValueChanged<String?> onDisclosureChanged;
  final ValueChanged<bool> onIncludeAiChanged;
  final ValueChanged<bool> onAgreePrivacyChanged;
  final ValueChanged<bool> onAgreeNotFalseChanged;
  final VoidCallback onSubmit;
  final VoidCallback? onSaveDraft;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewReportStepIndicator(currentStep: currentStep),
        const SizedBox(height: AppSpacing.lg),
        ReviewTargetCard(
          productName: productName,
          reviewContent: reviewContent,
          rtiScore: rtiScore,
          rtiGrade: rtiGrade,
        ),
        const SizedBox(height: AppSpacing.md),
        ReasonSelectorSection(
          selectedReasons: selectedReasons,
          onToggled: onReasonToggled,
        ),
        const SizedBox(height: AppSpacing.md),
        DetailInputSection(
          controller: detailController,
          reportType: reportType,
          disclosure: disclosure,
          onReportTypeChanged: onReportTypeChanged,
          onDisclosureChanged: onDisclosureChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        AiEvidenceSection(
          checked: includeAiEvidence,
          onChanged: onIncludeAiChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        AgreementSection(
          agreePrivacy: agreePrivacy,
          agreeNotFalse: agreeNotFalse,
          onPrivacyChanged: onAgreePrivacyChanged,
          onNotFalseChanged: onAgreeNotFalseChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportActionButtons(
          onSaveDraft: onSaveDraft,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
        ),
      ],
    );
  }
}
