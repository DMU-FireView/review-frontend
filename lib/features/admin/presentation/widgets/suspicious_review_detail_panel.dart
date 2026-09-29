import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_score_gauge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/trust_grade_tone.dart';

class SuspiciousReviewDetailPanel extends StatelessWidget {
  const SuspiciousReviewDetailPanel({
    super.key,
    required this.review,
    required this.onClose,
  });

  final AdminSuspiciousReview review;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final r = review;
    return AdminDetailPanel(
      title: '리뷰 상세 정보',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r.productName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          InkWell(
            onTap: () => context.go('/product/${r.productId}'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '상품 페이지 보기',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            label: 'RTI 분석 결과',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      r.rtiScore.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '점',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (r.trustGrade != null)
                      AdminStatusBadge(
                        label: r.trustGrade!.label,
                        tone: r.trustGrade!.tone,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AdminScoreGauge(score: r.rtiScore),
              ],
            ),
          ),
          _Section(
            label: '리뷰 내용',
            child: Text(
              r.content.isEmpty ? '-' : r.content,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          if (r.reasons.isNotEmpty)
            _Section(
              label: '탐지 신호 (${r.reasons.length})',
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final reason in r.reasons)
                    AdminStatusBadge(label: reason, tone: AdminBadgeTone.danger),
                ],
              ),
            ),
          _Section(
            label: '구매 인증',
            child: AdminStatusBadge(
              label: r.isVerifiedPurchase ? '인증됨' : '인증 안됨',
              tone: r.isVerifiedPurchase
                  ? AdminBadgeTone.success
                  : AdminBadgeTone.neutral,
            ),
          ),
          _Section(
            label: '작성자 정보',
            child: _InfoBox(rows: [
              ('작성자', r.reviewerNickname.isEmpty ? '-' : r.reviewerNickname),
              ('별점', '★ ${r.rating}'),
              ('작성일', formatAdminDateTime(r.writtenAt)),
            ]),
          ),
        ],
      ),
    );
  }
}

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
