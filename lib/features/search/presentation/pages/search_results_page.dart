import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/data/mock_search_results.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({required this.query, super.key});

  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final Set<String> _selectedCategories = {'이어폰'};
  final Set<String> _selectedPriceRanges = {};
  final Set<String> _selectedReviewConditions = {'리뷰 50개 이상'};
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  String _selectedQuickFilter = '전체';
  SearchSortOption _sortOption = SearchSortOption.accuracy;
  double _selectedRtiMinimum = 50;
  bool _isRtiFilterActive = false;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(text: '30000');
    _maxPriceController = TextEditingController(text: '200000');
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = mockSearchResultsFor(widget.query);
    final products = _sortProducts(_filterProducts(state.products));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _SearchHeader(
              query: state.query,
              onSearchSubmitted: (value) => _goToSearch(context, value),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1760,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.lg,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.lg,
                AppSpacing.xxxl,
              ),
              child: _SearchResultsBody(
                state: state,
                products: products,
                selectedQuickFilter: _selectedQuickFilter,
                selectedCategories: _selectedCategories,
                selectedPriceRanges: _selectedPriceRanges,
                selectedReviewConditions: _selectedReviewConditions,
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
                selectedRtiMinimum: _selectedRtiMinimum,
                sortOption: _sortOption,
                onQuickFilterSelected: _handleQuickFilterSelected,
                onCategoryToggled: _toggleCategory,
                onPriceRangeToggled: _togglePriceRange,
                onReviewConditionToggled: _toggleReviewCondition,
                onPriceChanged: () => setState(() {}),
                onRtiMinimumChanged: (value) {
                  setState(() {
                    _selectedRtiMinimum = value;
                    _isRtiFilterActive = true;
                  });
                },
                onSortChanged: (value) {
                  setState(() => _sortOption = value);
                },
                onResetFilters: _resetFilters,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToSearch(BuildContext context, String value) {
    final nextQuery = value.trim();
    if (nextQuery.isEmpty) {
      return;
    }

    context.goNamed(RouteNames.search, queryParameters: {'q': nextQuery});
  }

  void _handleQuickFilterSelected(String label) {
    setState(() {
      _selectedQuickFilter = label;
      if (label == 'RTI 80+') {
        _selectedRtiMinimum = 80;
        _isRtiFilterActive = true;
      }
    });
  }

  void _toggleCategory(String label) {
    setState(() {
      _toggleSetValue(_selectedCategories, label);
    });
  }

  void _togglePriceRange(String label) {
    setState(() {
      _toggleSetValue(_selectedPriceRanges, label);
    });
  }

  void _toggleReviewCondition(String label) {
    setState(() {
      _toggleSetValue(_selectedReviewConditions, label);
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories
        ..clear()
        ..add('이어폰');
      _selectedPriceRanges..clear();
      _minPriceController.text = '30000';
      _maxPriceController.text = '200000';
      _selectedReviewConditions
        ..clear()
        ..add('리뷰 50개 이상');
      _selectedQuickFilter = '전체';
      _sortOption = SearchSortOption.accuracy;
      _selectedRtiMinimum = 50;
      _isRtiFilterActive = false;
    });
  }

  List<SearchResultProduct> _filterProducts(
    List<SearchResultProduct> products,
  ) {
    return products
        .where((product) {
          if (_selectedCategories.isNotEmpty &&
              !_selectedCategories.contains(product.categoryDisplayName)) {
            return false;
          }

          if (_selectedPriceRanges.isNotEmpty &&
              !_selectedPriceRanges.any(
                (range) => _matchesPriceRange(product, range),
              )) {
            return false;
          }

          final minPrice = _parsePrice(_minPriceController.text);
          final maxPrice = _parsePrice(_maxPriceController.text);
          if (minPrice != null && product.price < minPrice) {
            return false;
          }
          if (maxPrice != null && product.price > maxPrice) {
            return false;
          }

          if (_isRtiFilterActive && product.avgRti < _selectedRtiMinimum) {
            return false;
          }

          if (_selectedReviewConditions.contains('리뷰 50개 이상') &&
              product.reviewCount < 50) {
            return false;
          }

          if (_selectedQuickFilter != '전체' &&
              !_matchesQuickFilter(product, _selectedQuickFilter)) {
            return false;
          }

          return true;
        })
        .toList(growable: false);
  }

  List<SearchResultProduct> _sortProducts(List<SearchResultProduct> products) {
    final sorted = [...products];
    switch (_sortOption) {
      case SearchSortOption.accuracy:
        return sorted;
      case SearchSortOption.rti:
        sorted.sort((a, b) => b.avgRti.compareTo(a.avgRti));
        break;
      case SearchSortOption.reviewCount:
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SearchSortOption.priceLow:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    return sorted;
  }

  bool _matchesPriceRange(SearchResultProduct product, String label) {
    return switch (label) {
      '3만원 이하' => product.price <= 30000,
      '3~7만원' => product.price > 30000 && product.price <= 70000,
      '7~15만원' => product.price > 70000 && product.price <= 150000,
      '15만원 이상' => product.price >= 150000,
      _ => true,
    };
  }

  int? _parsePrice(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }

    return int.tryParse(normalized);
  }

  bool _matchesQuickFilter(SearchResultProduct product, String label) {
    return switch (label) {
      'RTI 80+' => product.avgRti >= 80,
      '아이폰 추천' => product.name.contains('아이오') || product.avgRti >= 80,
      '통화 품질 우수' => product.name.contains('통화') || product.avgRating >= 4.7,
      '장시간 배터리' => product.price >= 70000,
      '가성비' => product.price <= 70000,
      '출시 6개월 이내' => product.name.contains('2026'),
      '무선충전 지원' => product.id.isEven,
      _ => true,
    };
  }

  void _toggleSetValue(Set<String> values, String value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.query, required this.onSearchSubmitted});

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: context.isMobile
              ? _MobileSearchHeader(
                  query: query,
                  onSearchSubmitted: onSearchSubmitted,
                )
              : _DesktopSearchHeader(
                  query: query,
                  onSearchSubmitted: onSearchSubmitted,
                ),
        ),
      ),
    );
  }
}

class _DesktopSearchHeader extends StatelessWidget {
  const _DesktopSearchHeader({
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 360,
          child: Row(
            children: [
              HomeLogo(onTap: () => context.go(RoutePaths.home)),
              const SizedBox(width: AppSpacing.xl),
              _HeaderLink(label: '고객센터'),
              const SizedBox(width: AppSpacing.lg),
              _HeaderLink(label: '판매자 입점'),
              const SizedBox(width: AppSpacing.lg),
              _HeaderLink(label: '앱 다운로드'),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 520,
              child: home.SearchBar(
                initialValue: query,
                onSubmitted: onSearchSubmitted,
                onSearchPressed: onSearchSubmitted,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 240,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              _HeaderAction(icon: Icons.person_outline, label: '로그인'),
              _HeaderAction(icon: Icons.favorite_border, label: '찜'),
              _HeaderAction(
                icon: Icons.shopping_cart_outlined,
                label: '장바구니',
                badge: '2',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileSearchHeader extends StatelessWidget {
  const _MobileSearchHeader({
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: () => context.go(RoutePaths.home)),
            const Spacer(),
            IconButton(
              tooltip: '홈',
              onPressed: () => context.go(RoutePaths.home),
              icon: const Icon(Icons.home_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        home.SearchBar(
          initialValue: query,
          onSubmitted: onSearchSubmitted,
          onSearchPressed: onSearchSubmitted,
        ),
      ],
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 24, color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge == null
              ? iconWidget
              : Badge(label: Text(badge!), child: iconWidget),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.state,
    required this.products,
    required this.selectedQuickFilter,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    required this.selectedReviewConditions,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.sortOption,
    required this.onQuickFilterSelected,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onSortChanged,
    required this.onResetFilters,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final String selectedQuickFilter;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final SearchSortOption sortOption;
  final ValueChanged<String> onQuickFilterSelected;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final ValueChanged<SearchSortOption> onSortChanged;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        height: 420,
        child: AppLoadingView(message: '검색 결과를 불러오는 중입니다.'),
      );
    }

    if (state.hasError) {
      return SizedBox(
        height: 420,
        child: AppErrorView(message: state.errorMessage!, retryLabel: '다시 검색'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchSummary(state: state),
        const SizedBox(height: AppSpacing.lg),
        _QuickFilterRow(
          filters: state.quickFilters,
          selectedFilter: selectedQuickFilter,
          onSelected: onQuickFilterSelected,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.isEmpty)
          SizedBox(
            height: 360,
            child: AppEmptyView(
              title: '검색 결과가 없어요',
              message: state.query.isEmpty
                  ? '상품명이나 카테고리를 입력하면 리뷰 기반 추천 상품을 보여드려요.'
                  : '다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.',
            ),
          )
        else if (context.isMobile)
          Column(
            children: [
              _FilterPanel(
                state: state,
                selectedCategories: selectedCategories,
                selectedPriceRanges: selectedPriceRanges,
                selectedReviewConditions: selectedReviewConditions,
                minPriceController: minPriceController,
                maxPriceController: maxPriceController,
                selectedRtiMinimum: selectedRtiMinimum,
                resultCount: products.length,
                compact: true,
                onCategoryToggled: onCategoryToggled,
                onPriceRangeToggled: onPriceRangeToggled,
                onReviewConditionToggled: onReviewConditionToggled,
                onPriceChanged: onPriceChanged,
                onRtiMinimumChanged: onRtiMinimumChanged,
                onResetFilters: onResetFilters,
              ),
              const SizedBox(height: AppSpacing.md),
              _ResultColumn(
                state: state,
                products: products,
                sortOption: sortOption,
                onSortChanged: onSortChanged,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: _FilterPanel(
                  state: state,
                  selectedCategories: selectedCategories,
                  selectedPriceRanges: selectedPriceRanges,
                  selectedReviewConditions: selectedReviewConditions,
                  minPriceController: minPriceController,
                  maxPriceController: maxPriceController,
                  selectedRtiMinimum: selectedRtiMinimum,
                  resultCount: products.length,
                  onCategoryToggled: onCategoryToggled,
                  onPriceRangeToggled: onPriceRangeToggled,
                  onReviewConditionToggled: onReviewConditionToggled,
                  onPriceChanged: onPriceChanged,
                  onRtiMinimumChanged: onRtiMinimumChanged,
                  onResetFilters: onResetFilters,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _ResultColumn(
                  state: state,
                  products: products,
                  sortOption: sortOption,
                  onSortChanged: onSortChanged,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _SearchSummary extends StatelessWidget {
  const _SearchSummary({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    final title = state.query.isEmpty
        ? '전체 상품 검색 결과'
        : '"${state.query}" 검색 결과';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.isMobile ? 24 : 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '총 ${state.displayTotalCount}개 상품 · RTI 신뢰 필터 적용 가능',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuickFilterRow extends StatelessWidget {
  const _QuickFilterRow({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<SearchFilterChipData> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _QuickFilterPill(
                label: filter.label == '전체'
                    ? '전체 ${filter.count}'
                    : filter.label,
                selected: filter.label == selectedFilter,
                onPressed: () => onSelected(filter.label),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickFilterPill extends StatelessWidget {
  const _QuickFilterPill({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.onPrimary : AppColors.textPrimary;

    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minWidth: 96, minHeight: 38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderStrong,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 14, color: foreground),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Text(
                label,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.state,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    required this.selectedReviewConditions,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.resultCount,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onResetFilters,
    this.compact = false,
  });

  final SearchResultsState state;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final int resultCount;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final VoidCallback onResetFilters;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '필터',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: onResetFilters, child: const Text('초기화')),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '카테고리',
              children: [
                for (final item in state.categoryFilters)
                  _CheckboxRow(
                    label: item.label,
                    trailing: '${item.count}',
                    selected: selectedCategories.contains(item.label),
                    onChanged: () => onCategoryToggled(item.label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '가격대',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _PriceBox(
                        controller: minPriceController,
                        onChanged: onPriceChanged,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: Text('~'),
                    ),
                    Expanded(
                      child: _PriceBox(
                        controller: maxPriceController,
                        onChanged: onPriceChanged,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Text('원'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final item in state.priceRanges)
                      _PriceRangeChip(
                        label: item.label,
                        selected: selectedPriceRanges.contains(item.label),
                        onPressed: () => onPriceRangeToggled(item.label),
                      ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '브랜드',
              children: const [_SelectBox(label: '브랜드를 선택하세요')],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: 'RTI 신뢰 점수',
              trailing: '${selectedRtiMinimum.round()}점 이상',
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbColor: AppColors.surface,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    overlayColor: AppColors.primary.withValues(alpha: 0.12),
                    thumbShape: const _OutlinedRoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      borderWidth: 2,
                      borderColor: AppColors.primary,
                    ),
                  ),
                  child: Slider(
                    value: selectedRtiMinimum,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: onRtiMinimumChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _ScaleLabel(label: '0'),
                    _ScaleLabel(label: '50'),
                    _ScaleLabel(label: '75'),
                    _ScaleLabel(label: '100'),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '리뷰 조건',
              children: [
                for (final label in const [
                  '리뷰 50개 이상',
                  '사진 포함',
                  '최근 30일 리뷰 포함',
                ])
                  _CheckboxRow(
                    label: label,
                    selected: selectedReviewConditions.contains(label),
                    onChanged: () => onReviewConditionToggled(label),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: Text('$resultCount개 결과 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...children,
      ],
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.label,
    required this.onChanged,
    this.trailing,
    this.selected = false,
  });

  final String label;
  final VoidCallback onChanged;
  final String? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: Checkbox(value: selected, onChanged: (_) => onChanged()),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  const _PriceBox({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) => onChanged(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.borderStrong),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.borderStrong),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _PriceRangeChip extends StatelessWidget {
  const _PriceRangeChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: AppRadius.small,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.small,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.small,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderStrong,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _OutlinedRoundSliderThumbShape extends SliderComponentShape {
  const _OutlinedRoundSliderThumbShape({
    required this.enabledThumbRadius,
    required this.borderWidth,
    required this.borderColor,
  });

  final double enabledThumbRadius;
  final double borderWidth;
  final Color borderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      enabledThumbRadius,
      Paint()..color = sliderTheme.thumbColor ?? AppColors.surface,
    );
    canvas.drawCircle(
      center,
      enabledThumbRadius - borderWidth / 2,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }
}

class _ResultColumn extends StatelessWidget {
  const _ResultColumn({
    required this.state,
    required this.products,
    required this.sortOption,
    required this.onSortChanged,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final SearchSortOption sortOption;
  final ValueChanged<SearchSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              '${products.length}개 결과',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            PopupMenuButton<SearchSortOption>(
              initialValue: sortOption,
              tooltip: '정렬',
              onSelected: onSortChanged,
              itemBuilder: (context) => [
                for (final option in SearchSortOption.values)
                  PopupMenuItem(value: option, child: Text(option.label)),
              ],
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderStrong),
                  borderRadius: AppRadius.small,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sortOption.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.expand_more, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (products.isEmpty)
          const SizedBox(
            height: 360,
            child: AppEmptyView(
              title: '필터에 맞는 상품이 없어요',
              message: '필터를 초기화하거나 조건을 조금 넓혀보세요.',
            ),
          )
        else ...[
          _ProductGrid(products: products),
          const SizedBox(height: AppSpacing.lg),
          const _Pagination(),
        ],
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<SearchResultProduct> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1500
            ? 5
            : width >= 1180
            ? 4
            : width >= 820
            ? 3
            : width >= 560
            ? 2
            : 1;
        final cardHeight = switch (columns) {
          1 => 480.0,
          2 => 450.0,
          3 => 430.0,
          4 => 400.0,
          _ => 380.0,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            return _SearchProductCard(product: products[index]);
          },
        );
      },
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  const _SearchProductCard({required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    final rtiColor = _colorFromHex(product.rtiColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8.5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFBFF),
                        borderRadius: AppRadius.medium,
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.medium,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(color: AppColors.surfaceMuted),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _RtiBadge(
                      value: product.avgRti.round(),
                      color: rtiColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              mockBrandFor(product),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.name,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      product.avgRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '(리뷰 ${_formatCount(product.reviewCount)})',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                _DeliveryBadge(label: mockBadgeFor(product)),
              ],
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatPrice(product.price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SquareIconButton(
                  icon: Icons.favorite_border,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                _SquareIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(onPressed: () {}, child: const Text('상품 상세 보기')),
          ],
        ),
      ),
    );
  }
}

class _RtiBadge extends StatelessWidget {
  const _RtiBadge({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.76),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_outlined, color: color, size: 16),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'RTI $value',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryBadge extends StatelessWidget {
  const _DeliveryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 38,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    const pages = ['1', '2', '3', '4', '5'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageButton(icon: Icons.chevron_left, selected: false),
        for (final page in pages)
          _PageButton(label: page, selected: page == '1'),
        _PageButton(icon: Icons.chevron_right, selected: false),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({this.label, this.icon, required this.selected});

  final String? label;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: SizedBox.square(
        dimension: 40,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: selected ? AppColors.primary : AppColors.surface,
            foregroundColor: selected
                ? AppColors.onPrimary
                : AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
          ),
          child: icon == null ? Text(label!) : Icon(icon, size: 18),
        ),
      ),
    );
  }
}

String _formatPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return '$buffer원';
}

String _formatCount(int count) {
  final digits = count.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

Color _colorFromHex(String hex) {
  final normalized = hex.replaceFirst('#', '');
  final value = int.tryParse('FF$normalized', radix: 16);
  if (value == null) {
    return AppColors.primary;
  }

  return Color(value);
}
