import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';

enum WishlistSortOption {
  recent(label: '최근 저장 순'),
  priceLow(label: '낮은 가격 순'),
  priceHigh(label: '높은 가격 순'),
  rti(label: 'RTI 높은 순'),
  reviewCount(label: '리뷰 많은 순');

  const WishlistSortOption({required this.label});

  final String label;
}

enum WishlistFilterOption {
  all(label: '전체'),
  priceDrop(label: '가격 하락'),
  rti(label: 'RTI 점수'),
  lowestPrice(label: '최저 가격'),
  brand(label: '브랜드'),
  category(label: '카테고리');

  const WishlistFilterOption({required this.label});

  final String label;
}

class WishlistFilterBar extends StatelessWidget {
  const WishlistFilterBar({
    super.key,
    required this.items,
    required this.selectedFilter,
    required this.sortOption,
    required this.onFilterSelected,
    required this.onSortChanged,
  });

  final List<WishlistItem> items;
  final WishlistFilterOption selectedFilter;
  final WishlistSortOption sortOption;
  final ValueChanged<WishlistFilterOption> onFilterSelected;
  final ValueChanged<WishlistSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final priceDropCount = items.where((i) => i.isPriceDrop).length;

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in WishlistFilterOption.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: _FilterChip(
                      label: filter.label,
                      badge: filter == WishlistFilterOption.priceDrop && priceDropCount > 0
                          ? priceDropCount
                          : null,
                      selected: selectedFilter == filter,
                      onTap: () => onFilterSelected(filter),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _SortDropdown(
          value: sortOption,
          onChanged: onSortChanged,
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
    this.badge,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? AppColors.onPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badge != null && badge! > 0) ...[
              const SizedBox(width: AppSpacing.xxs),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? AppColors.onPrimary : AppColors.error,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                    vertical: 1,
                  ),
                  child: Text(
                    '$badge',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? AppColors.error : AppColors.onPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
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

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.value, required this.onChanged});

  final WishlistSortOption value;
  final ValueChanged<WishlistSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<WishlistSortOption>(
            value: value,
            isDense: true,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            items: WishlistSortOption.values
                .map(
                  (opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(opt.label),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}
