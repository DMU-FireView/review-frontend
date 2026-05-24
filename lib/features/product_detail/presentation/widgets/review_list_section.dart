import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

enum ReviewSortOption { newest, verified, withPhoto, rtiHigh }

class ReviewListSection extends StatefulWidget {
  const ReviewListSection({super.key, required this.reviews});

  final List<ProductReview> reviews;

  @override
  State<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends State<ReviewListSection> {
  ReviewSortOption _sortOption = ReviewSortOption.newest;
  bool _verifiedOnly = false;

  List<ProductReview> get _filteredSortedReviews {
    var list = List<ProductReview>.from(widget.reviews);

    if (_verifiedOnly) {
      list = list.where((r) => r.isVerifiedPurchase).toList();
    }

    return switch (_sortOption) {
      ReviewSortOption.newest => list,
      ReviewSortOption.verified =>
        list.where((r) => r.isVerifiedPurchase).toList(),
      ReviewSortOption.withPhoto =>
        list.where((r) => r.imageUrls.isNotEmpty).toList(),
      ReviewSortOption.rtiHigh =>
        (list..sort((a, b) => b.rtiScore.compareTo(a.rtiScore))),
    };
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _filteredSortedReviews;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterRow(
          sortOption: _sortOption,
          verifiedOnly: _verifiedOnly,
          onSortChanged: (v) => setState(() => _sortOption = v),
          onVerifiedChanged: (v) => setState(() => _verifiedOnly = v),
        ),
        const SizedBox(height: AppSpacing.md),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                '해당 조건에 맞는 리뷰가 없습니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ...reviews.map((review) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ReviewCard(review: review),
        )),
        Center(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text('리뷰 더보기'),
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.sortOption,
    required this.verifiedOnly,
    required this.onSortChanged,
    required this.onVerifiedChanged,
  });

  final ReviewSortOption sortOption;
  final bool verifiedOnly;
  final ValueChanged<ReviewSortOption> onSortChanged;
  final ValueChanged<bool> onVerifiedChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _FilterChip(
          label: '최신순',
          selected: sortOption == ReviewSortOption.newest,
          onTap: () => onSortChanged(ReviewSortOption.newest),
        ),
        _FilterChip(
          label: '구매인증',
          selected: sortOption == ReviewSortOption.verified,
          onTap: () => onSortChanged(ReviewSortOption.verified),
        ),
        _FilterChip(
          label: '사진 포함',
          selected: sortOption == ReviewSortOption.withPhoto,
          onTap: () => onSortChanged(ReviewSortOption.withPhoto),
        ),
        _FilterChip(
          label: 'RTI 높은순',
          selected: sortOption == ReviewSortOption.rtiHigh,
          onTap: () => onSortChanged(ReviewSortOption.rtiHigh),
        ),
        const _Divider(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: verifiedOnly,
                onChanged: (v) => onVerifiedChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '구매인증만 보기',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.small,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      color: AppColors.borderStrong,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final rtiColor = colorFromHex(review.rtiColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(name: review.authorName),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.authorName,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          if (review.isVerifiedPurchase) ...[
                            const SizedBox(width: AppSpacing.xxs),
                            _VerifiedBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            Icon(
                              i < review.rating ? Icons.star : Icons.star_border,
                              color: const Color(0xFFF59E0B),
                              size: 13,
                            ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${review.createdAt} · ${review.platform}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _RtiBadgeSmall(
                  score: review.rtiScore,
                  label: review.rtiLabel,
                  color: rtiColor,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Icon(
                  Icons.more_vert,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              review.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
            if (review.imageUrls.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.imageUrls.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: AppRadius.small,
                    child: Image.network(
                      review.imageUrls[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox.square(dimension: 80),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          '구매인증',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _RtiBadgeSmall extends StatelessWidget {
  const _RtiBadgeSmall({
    required this.score,
    required this.label,
    required this.color,
  });

  final int score;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, size: 11, color: color),
                const SizedBox(width: 2),
                Text(
                  'RTI $score',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
