import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

void showReviewRtiAnalysisDialog(BuildContext context, ProductReview review) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.overlay,
    builder: (_) => ReviewRtiAnalysisDialog(review: review),
  );
}

class ReviewRtiAnalysisDialog extends StatelessWidget {
  const ReviewRtiAnalysisDialog({super.key, required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1060, maxHeight: 800),
        child: ClipRRect(
          borderRadius: AppRadius.large,
          child: Material(
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(onClose: () => Navigator.of(context).pop()),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RtiScoreSection(review: review),
                        const SizedBox(height: AppSpacing.sm),
                        _DialogBody(review: review),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),
                _DialogFooter(onClose: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Analysis',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '리뷰 상세 분석',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '선택한 리뷰의 문장 패턴, 작성 맥락, 네트워크 신호를 종합해 RTI 점수와 판단 근거를 설명합니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceMuted,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RTI Score Section ────────────────────────────────────────────────────────

class _RtiScoreSection extends StatelessWidget {
  const _RtiScoreSection({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(review.rtiColor);
    final detail = review.rtiDetail;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RTI 점수',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${review.rtiScore}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _RtiGradeBadge(label: review.rtiLabel, color: color),
                ],
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          Container(width: 1, height: 60, color: AppColors.border),
          const SizedBox(width: AppSpacing.lg),
          if (detail != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.summaryDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xxs,
                    children: detail.summaryTags
                        .map((t) => _SummaryTagChip(tag: t))
                        .toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RtiGradeBadge extends StatelessWidget {
  const _RtiGradeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTagChip extends StatelessWidget {
  const _SummaryTagChip({required this.tag});

  final RtiSummaryTag tag;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (tag.type) {
      RtiTagType.positive => (AppColors.success, Icons.check_circle_outline),
      RtiTagType.info => (const Color(0xFFD97706), Icons.lightbulb_outline),
      RtiTagType.warning => (AppColors.error, Icons.warning_amber_outlined),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dialog Body ─────────────────────────────────────────────────────────────

class _DialogBody extends StatelessWidget {
  const _DialogBody({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final detail = review.rtiDetail;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SelectedReviewSection(review: review),
              if (detail != null && detail.sentenceHighlights.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _SentenceHighlightsSection(
                  highlights: detail.sentenceHighlights,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        if (detail != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RtiSignalsSection(signals: detail.signals),
                const SizedBox(height: AppSpacing.sm),
                _JudgmentBasisSection(bases: detail.judgmentBases),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Selected Review Section ─────────────────────────────────────────────────

class _SelectedReviewSection extends StatelessWidget {
  const _SelectedReviewSection({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '선택된 리뷰',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewAuthorRow(review: review),
          const SizedBox(height: AppSpacing.sm),
          _HighlightedReviewContent(review: review),
          if (review.hashtags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: review.hashtags
                  .map(
                    (tag) => Text(
                      '# $tag',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.xs),
                itemBuilder: (_, i) {
                  final isLast = i == review.imageUrls.length - 1 &&
                      review.imageUrls.length > 3 &&
                      i == 3;
                  if (isLast) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.small,
                          child: Image.network(
                            review.imageUrls[i],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: AppRadius.small,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+${review.imageUrls.length - 3}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (i > 3) return const SizedBox.shrink();
                  return ClipRRect(
                    borderRadius: AppRadius.small,
                    child: Image.network(
                      review.imageUrls[i],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox.square(dimension: 60),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewAuthorRow extends StatelessWidget {
  const _ReviewAuthorRow({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            review.authorName.isNotEmpty ? review.authorName[0].toUpperCase() : '?',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  _PlatformBadge(platform: review.platform),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (review.isVerifiedPurchase) ...[
                    const Icon(
                      Icons.shield_outlined,
                      size: 11,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '구매인증',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  for (var i = 0; i < 5; i++)
                    Icon(
                      i < review.rating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFF59E0B),
                      size: 12,
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    review.createdAt,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final String platform;

  Color get _color {
    return switch (platform) {
      '네이버쇼핑' => const Color(0xFF03C75A),
      '쿠팡' => const Color(0xFFEE2F3B),
      '11번가' => const Color(0xFFFF5000),
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        platform,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HighlightedReviewContent extends StatelessWidget {
  const _HighlightedReviewContent({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final detail = review.rtiDetail;
    final baseStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          height: 1.65,
        ) ??
        const TextStyle();

    if (detail == null || detail.sentenceHighlights.isEmpty) {
      return Text(review.content, style: baseStyle);
    }

    final content = review.content;
    final spans = <TextSpan>[];
    int lastEnd = 0;

    final segments = <(int, int, RtiSentenceHighlight)>[];
    for (final h in detail.sentenceHighlights) {
      final idx = content.indexOf(h.sentence);
      if (idx >= 0) {
        segments.add((idx, idx + h.sentence.length, h));
      }
    }
    segments.sort((a, b) => a.$1.compareTo(b.$1));

    for (final (start, end, h) in segments) {
      if (start > lastEnd) {
        spans.add(TextSpan(
          text: content.substring(lastEnd, start),
          style: baseStyle,
        ));
      }
      final hColor = colorFromHex(h.color);
      spans.add(TextSpan(
        text: content.substring(start, end),
        style: baseStyle.copyWith(
          backgroundColor: hColor.withValues(alpha: 0.12),
          color: hColor.withValues(alpha: 0.85),
          fontWeight: FontWeight.w600,
        ),
      ));
      lastEnd = end;
    }

    if (lastEnd < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastEnd),
        style: baseStyle,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}

// ─── RTI Signals Section ──────────────────────────────────────────────────────

class _RtiSignalsSection extends StatelessWidget {
  const _RtiSignalsSection({required this.signals});

  final List<RtiSignal> signals;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'A. RTI 구성 신호',
      showInfo: true,
      child: Column(
        children: signals
            .map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _SignalBar(signal: s),
                ))
            .toList(),
      ),
    );
  }
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.signal});

  final RtiSignal signal;

  IconData get _icon => switch (signal.iconType) {
        'text' => Icons.person_outline,
        'behavior' => Icons.check_circle_outline,
        'pattern' => Icons.auto_awesome_outlined,
        'purchase' => Icons.verified_user_outlined,
        _ => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(signal.color);
    final ratio = (signal.score / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 14, color: color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signal.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 7,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 32,
          child: Text(
            '${signal.score}',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Judgment Basis Section ───────────────────────────────────────────────────

class _JudgmentBasisSection extends StatelessWidget {
  const _JudgmentBasisSection({required this.bases});

  final List<RtiJudgmentBasis> bases;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'B. 판단 근거',
      showInfo: true,
      child: Column(
        children: bases
            .map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _JudgmentBasisItem(basis: b),
                ))
            .toList(),
      ),
    );
  }
}

class _JudgmentBasisItem extends StatelessWidget {
  const _JudgmentBasisItem({required this.basis});

  final RtiJudgmentBasis basis;

  IconData get _icon => switch (basis.iconType) {
        'repeat' => Icons.camera_alt_outlined,
        'context' => Icons.sentiment_satisfied_alt_outlined,
        'history' => Icons.scatter_plot_outlined,
        'similarity' => Icons.alarm_outlined,
        _ => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(basis.color);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 14, color: color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                basis.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                basis.description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${basis.percentage}%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Sentence Highlights Section ─────────────────────────────────────────────

class _SentenceHighlightsSection extends StatelessWidget {
  const _SentenceHighlightsSection({required this.highlights});

  final List<RtiSentenceHighlight> highlights;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'C. 문장 근거 하이라이트',
      showInfo: true,
      child: Column(
        children: highlights
            .map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _SentenceHighlightItem(highlight: h),
                ))
            .toList(),
      ),
    );
  }
}

class _SentenceHighlightItem extends StatelessWidget {
  const _SentenceHighlightItem({required this.highlight});

  final RtiSentenceHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(highlight.color);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.small,
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          const Text(
            '"',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              highlight.sentence,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              highlight.tag,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 13, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '분석 결과는 참고용이며 최종 판단은 여러 리뷰를 함께 확인해주세요.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: onClose,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: const Text('닫기', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: const Text('분석 기준', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: const Text('리뷰 신고', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ─── Shared: Section Card ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.showInfo = false,
  });

  final String title;
  final Widget child;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (showInfo) ...[
                const SizedBox(width: AppSpacing.xxs),
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}
