import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

class PriceComparisonTable extends StatefulWidget {
  const PriceComparisonTable({
    super.key,
    required this.comparisons,
    required this.totalSellerCount,
  });

  final List<PriceComparison> comparisons;
  final int totalSellerCount;

  @override
  State<PriceComparisonTable> createState() => _PriceComparisonTableState();
}

class _PriceComparisonTableState extends State<PriceComparisonTable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    '판매처',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '최저가',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '배송',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          for (final item in (_expanded
              ? widget.comparisons
              : widget.comparisons.take(3).toList()))
            _PriceRow(comparison: item),
          const Divider(height: 1, color: AppColors.border),
          _ExpandButton(
            totalCount: widget.totalSellerCount,
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.comparison});

  final PriceComparison comparison;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _SellerLogo(tag: comparison.sellerLogoTag),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        comparison.sellerName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (comparison.isLowest) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _LowestBadge(),
                    ],
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  formatSearchPrice(comparison.price),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  comparison.deliveryInfo,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 80,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    minimumSize: const Size(60, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: comparison.isOfficial
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    side: BorderSide(
                      color: comparison.isOfficial
                          ? AppColors.primary
                          : AppColors.borderStrong,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.small,
                    ),
                  ),
                  child: Text(
                    comparison.linkLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _SellerLogo extends StatelessWidget {
  const _SellerLogo({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final (color, letter) = switch (tag) {
      'coupang' => (const Color(0xFFEF4444), 'C'),
      'naver' => (const Color(0xFF22C55E), 'N'),
      '11st' => (const Color(0xFFF97316), '11'),
      'official' => (AppColors.primary, 'O'),
      _ => (AppColors.textSecondary, tag.isNotEmpty ? tag[0].toUpperCase() : '?'),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: letter.length > 1 ? 9 : 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _LowestBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFBBF24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          '최저가',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFFD97706),
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({
    required this.totalCount,
    required this.expanded,
    required this.onTap,
  });

  final int totalCount;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '전체 $totalCount개 판매처 가격 비교',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
