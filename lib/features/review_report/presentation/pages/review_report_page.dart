import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

import 'package:re_view_front/features/review_report/presentation/providers/review_report_providers.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_draft.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_state.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_main_form.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_page_header.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_step_indicator.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/report_side_panel.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(reviewReportDraftProvider.notifier);
      notifier.bind(widget.reviewId);
      final draft = ref.read(reviewReportDraftProvider);
      if (_detailController.text != draft.detail) {
        _detailController.value = TextEditingValue(
          text: draft.detail,
          selection: TextSelection.collapsed(offset: draft.detail.length),
        );
      }
      _detailController.addListener(_onDetailChanged);
    });
  }

  @override
  void dispose() {
    _detailController.removeListener(_onDetailChanged);
    _detailController.dispose();
    super.dispose();
  }

  void _onDetailChanged() {
    ref
        .read(reviewReportDraftProvider.notifier)
        .setDetail(_detailController.text);
  }

  ReportStep _currentStepOf(ReviewReportDraft draft) {
    final hasDetailInput = draft.detail.trim().isNotEmpty ||
        draft.reportType != null ||
        draft.disclosure != null ||
        draft.attachments.isNotEmpty;
    final detailReady = draft.detail.trim().length >= 20;

    if (draft.agreePrivacy &&
        draft.agreeNotFalse &&
        detailReady &&
        draft.reasons.isNotEmpty) {
      return ReportStep.submit;
    }
    if (hasDetailInput) return ReportStep.detail;
    if (draft.reasons.isNotEmpty) return ReportStep.reason;
    return ReportStep.target;
  }

  void _submit(ReviewReportDraft draft) {
    if (draft.reasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('신고 사유를 1개 이상 선택해주세요.')),
      );
      return;
    }
    if (!draft.agreePrivacy || !draft.agreeNotFalse) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('동의 항목을 모두 확인해주세요.')),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(reviewReportViewModelProvider.notifier).submit(
          reviewId: widget.reviewId,
          reason: draft.reasons.first.code,
          detail: draft.detail.trim(),
          includeAiEvidence: draft.includeAiEvidence,
        );
  }

  void _showSuccessDialog() {
    ref.read(reviewReportDraftProvider.notifier).clear();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('신고 접수 완료'),
        content: const Text('신고가 접수되었습니다.\n처리 결과는 피드백 내역에서 확인할 수 있어요.'),
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

  void _showDuplicateDialog() {
    ref.read(reportedReviewIdsProvider.notifier).add(widget.reviewId);
    ref.read(reviewReportDraftProvider.notifier).clear();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('이미 신고한 리뷰'),
        content: const Text('이 리뷰는 이미 신고하셨습니다.\n중복 신고는 접수되지 않아요.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewReportViewModelProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final draft = ref.watch(reviewReportDraftProvider);

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutePaths.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final isMatchedDraft = draft.reviewId == widget.reviewId;
    final draftDetail = isMatchedDraft ? draft.detail : '';
    if (_detailController.text != draftDetail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_detailController.text != draftDetail) {
          _detailController.value = TextEditingValue(
            text: draftDetail,
            selection: TextSelection.collapsed(offset: draftDetail.length),
          );
        }
      });
    }

    ref.listen(reviewReportViewModelProvider, (_, next) {
      if (next is ReviewReportSuccess) {
        _showSuccessDialog();
      } else if (next is ReviewReportFailure) {
        if (next.isDuplicate) {
          _showDuplicateDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    });

    final isSubmitting = state is ReviewReportSubmitting;
    final draftNotifier = ref.read(reviewReportDraftProvider.notifier);
    final currentStep = _currentStepOf(draft);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              showCategoryNav: false,
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onMyPagePressed: () => context.go(RoutePaths.myPage),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.dashboard),
              onLogoutPressed: () =>
                  ref.read(authTokenStoreProvider.notifier).clear(),
              onNavItemPressed: (item) => context.goNamed(
                RouteNames.search,
                queryParameters: {'q': item},
              ),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              onLogoPressed: () => context.goNamed(RouteNames.home),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1280,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReviewReportPageHeader(
                      onViewFeedback: () => context.go(RoutePaths.myPage),
                      onBreadcrumbHome: () => context.go(RoutePaths.home),
                      onBreadcrumbReport: () => context.go(RoutePaths.myPage),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    context.isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _mainForm(
                                isSubmitting,
                                draft,
                                draftNotifier,
                                currentStep,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              ReportSidePanel(
                                selectedCount: draft.reasons.length,
                                evidenceCount:
                                    draft.includeAiEvidence ? 4 : 0,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 65,
                                child: _mainForm(
                                  isSubmitting,
                                  draft,
                                  draftNotifier,
                                  currentStep,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xl),
                              SizedBox(
                                width: 300,
                                child: ReportSidePanel(
                                  selectedCount: draft.reasons.length,
                                  evidenceCount:
                                      draft.includeAiEvidence ? 4 : 0,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainForm(
    bool isSubmitting,
    ReviewReportDraft draft,
    ReviewReportDraftNotifier draftNotifier,
    ReportStep currentStep,
  ) {
    return ReviewReportMainForm(
      productName: widget.productName,
      reviewContent: widget.reviewContent,
      rtiScore: widget.rtiScore,
      rtiGrade: widget.rtiGrade,
      selectedReasons: draft.reasons,
      detailController: _detailController,
      reportType: draft.reportType,
      disclosure: draft.disclosure,
      includeAiEvidence: draft.includeAiEvidence,
      agreePrivacy: draft.agreePrivacy,
      agreeNotFalse: draft.agreeNotFalse,
      currentStep: currentStep,
      onReasonToggled: draftNotifier.toggleReason,
      onReportTypeChanged: draftNotifier.setReportType,
      onDisclosureChanged: draftNotifier.setDisclosure,
      onIncludeAiChanged: draftNotifier.setIncludeAiEvidence,
      onAgreePrivacyChanged: draftNotifier.setAgreePrivacy,
      onAgreeNotFalseChanged: draftNotifier.setAgreeNotFalse,
      attachments: draft.attachments,
      onAttachmentsChanged: draftNotifier.setAttachments,
      onSubmit: () => _submit(draft),
      isSubmitting: isSubmitting,
    );
  }
}
