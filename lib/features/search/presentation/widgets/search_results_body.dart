import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_panel.dart';
import 'package:re_view_front/features/search/presentation/widgets/result_column.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_summary.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';

class SearchResultsBody extends StatelessWidget {
  const SearchResultsBody({
    super.key,
    required this.state,
    required this.products,
    required this.selectedQuickFilter,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    required this.selectedReviewConditions,
    required this.selectedAttributeFilters,
    required this.selectedBrand,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.sortOption,
    required this.viewMode,
    required this.currentPage,
    required this.pageSize,
    required this.onQuickFilterSelected,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onAttributeToggled,
    required this.onBrandSelected,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onSortChanged,
    required this.onPageSelected,
    required this.onPageSizeChanged,
    required this.onViewModeChanged,
    required this.onResetFilters,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final String selectedQuickFilter;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final Set<String> selectedAttributeFilters;
  final String? selectedBrand;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final SearchSortOption sortOption;
  final SearchViewMode viewMode;
  final int currentPage;
  final int pageSize;
  final ValueChanged<String> onQuickFilterSelected;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final ValueChanged<String> onAttributeToggled;
  final ValueChanged<String?> onBrandSelected;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSelected;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<SearchViewMode> onViewModeChanged;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SearchProductGridSkeleton();
    }

    if (state.hasError) {
      return SizedBox(
        height: 420,
        child: AppErrorView(message: state.errorMessage!, retryLabel: '다시 검색'),
      );
    }

    final useSingleColumn =
        context.isMobile || MediaQuery.sizeOf(context).width < 1080;

    if (useSingleColumn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchSummary(state: state),
          const SizedBox(height: AppSpacing.lg),
          QuickFilterRow(
            filters: state.quickFilters,
            selectedFilter: selectedQuickFilter,
            onSelected: onQuickFilterSelected,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.isEmpty)
            SearchEmptyState(state: state)
          else ...[
            FilterPanel(
              state: state,
              selectedCategories: selectedCategories,
              selectedPriceRanges: selectedPriceRanges,
              selectedReviewConditions: selectedReviewConditions,
              selectedAttributeFilters: selectedAttributeFilters,
              selectedBrand: selectedBrand,
              minPriceController: minPriceController,
              maxPriceController: maxPriceController,
              selectedRtiMinimum: selectedRtiMinimum,
              resultCount: products.length,
              compact: true,
              onCategoryToggled: onCategoryToggled,
              onPriceRangeToggled: onPriceRangeToggled,
              onReviewConditionToggled: onReviewConditionToggled,
              onAttributeToggled: onAttributeToggled,
              onBrandSelected: onBrandSelected,
              onPriceChanged: onPriceChanged,
              onRtiMinimumChanged: onRtiMinimumChanged,
              onResetFilters: onResetFilters,
            ),
            const SizedBox(height: AppSpacing.md),
            ResultColumn(
              state: state,
              products: products,
              sortOption: sortOption,
              viewMode: viewMode,
              currentPage: currentPage,
              pageSize: pageSize,
              onSortChanged: onSortChanged,
              onPageSelected: onPageSelected,
              onPageSizeChanged: onPageSizeChanged,
              onViewModeChanged: onViewModeChanged,
            ),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 252,
          child: FilterPanel(
            state: state,
            selectedCategories: selectedCategories,
            selectedPriceRanges: selectedPriceRanges,
            selectedReviewConditions: selectedReviewConditions,
            selectedAttributeFilters: selectedAttributeFilters,
            selectedBrand: selectedBrand,
            minPriceController: minPriceController,
            maxPriceController: maxPriceController,
            selectedRtiMinimum: selectedRtiMinimum,
            resultCount: products.length,
            onCategoryToggled: onCategoryToggled,
            onPriceRangeToggled: onPriceRangeToggled,
            onReviewConditionToggled: onReviewConditionToggled,
            onAttributeToggled: onAttributeToggled,
            onBrandSelected: onBrandSelected,
            onPriceChanged: onPriceChanged,
            onRtiMinimumChanged: onRtiMinimumChanged,
            onResetFilters: onResetFilters,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchSummary(state: state),
              const SizedBox(height: AppSpacing.lg),
              QuickFilterRow(
                filters: state.quickFilters,
                selectedFilter: selectedQuickFilter,
                onSelected: onQuickFilterSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isEmpty)
                SearchEmptyState(state: state)
              else
                ResultColumn(
                  state: state,
                  products: products,
                  sortOption: sortOption,
                  viewMode: viewMode,
                  currentPage: currentPage,
                  pageSize: pageSize,
                  onSortChanged: onSortChanged,
                  onPageSelected: onPageSelected,
                  onPageSizeChanged: onPageSizeChanged,
                  onViewModeChanged: onViewModeChanged,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
