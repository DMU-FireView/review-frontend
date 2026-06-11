import 'package:file_picker/file_picker.dart';
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

  final Set<ReportReason> _selectedReasons = {};
  String? _reportType;
  String? _disclosure;
  bool _includeAiEvidence = false;
  bool _agreePrivacy = false;
  bool _agreeNotFalse = false;
  List<PlatformFile> _attachments = const [];

  @override
  void initState() {
    super.initState();
    _detailController.addListener(_rebuild);
  }

  @override
  void dispose() {
    _detailController.removeListener(_rebuild);
    _detailController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  ReportStep get _currentStep {
    final hasDetailInput = _detailController.text.trim().isNotEmpty ||
        _reportType != null ||
        _disclosure != null ||
        _attachments.isNotEmpty;
    final detailReady = _detailController.text.trim().length >= 20;

    if (_agreePrivacy && _agreeNotFalse && detailReady &&
        _selectedReasons.isNotEmpty) {
      return ReportStep.submit;
    }
    if (hasDetailInput) return ReportStep.detail;
    if (_selectedReasons.isNotEmpty) return ReportStep.reason;
    return ReportStep.target;
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

    ref
        .read(reviewReportViewModelProvider.notifier)
        .submit(
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

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutePaths.login);
      });
      return const Scaffold(body: SizedBox.shrink());
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
                              _mainForm(isSubmitting),
                              const SizedBox(height: AppSpacing.lg),
                              ReportSidePanel(
                                selectedCount: _selectedReasons.length,
                                evidenceCount: _includeAiEvidence ? 4 : 0,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 65,
                                child: _mainForm(isSubmitting),
                              ),
                              const SizedBox(width: AppSpacing.xl),
                              SizedBox(
                                width: 300,
                                child: ReportSidePanel(
                                  selectedCount: _selectedReasons.length,
                                  evidenceCount: _includeAiEvidence ? 4 : 0,
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

  Widget _mainForm(bool isSubmitting) {
    return ReviewReportMainForm(
      productName: widget.productName,
      reviewContent: widget.reviewContent,
      rtiScore: widget.rtiScore,
      rtiGrade: widget.rtiGrade,
      selectedReasons: _selectedReasons,
      detailController: _detailController,
      reportType: _reportType,
      disclosure: _disclosure,
      includeAiEvidence: _includeAiEvidence,
      agreePrivacy: _agreePrivacy,
      agreeNotFalse: _agreeNotFalse,
      currentStep: _currentStep,
      onReasonToggled: _toggleReason,
      onReportTypeChanged: (v) => setState(() => _reportType = v),
      onDisclosureChanged: (v) => setState(() => _disclosure = v),
      onIncludeAiChanged: (v) => setState(() => _includeAiEvidence = v),
      onAgreePrivacyChanged: (v) => setState(() => _agreePrivacy = v),
      onAgreeNotFalseChanged: (v) => setState(() => _agreeNotFalse = v),
      attachments: _attachments,
      onAttachmentsChanged: (v) => setState(() => _attachments = v),
      onSubmit: _submit,
      isSubmitting: isSubmitting,
    );
  }
}
