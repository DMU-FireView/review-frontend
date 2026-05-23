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
  final Set<String> _selectedAttributeFilters = {};
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  String _selectedQuickFilter = '전체';
  String? _selectedBrand;
  SearchSortOption _sortOption = SearchSortOption.accuracy;
  double _selectedRtiMinimum = 50;
  bool _isPriceFilterActive = false;
  bool _isRtiFilterActive = false;
  int _currentPage = 1;
  int _pageSize = 60;
  String? _lastPriceRangeQuery;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
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
    _syncInitialPriceRange(state.products, state.query);
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
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.lg,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: _SearchResultsBody(
                state: state,
                products: products,
                selectedQuickFilter: _selectedQuickFilter,
                selectedCategories: _selectedCategories,
                selectedPriceRanges: _selectedPriceRanges,
                selectedReviewConditions: _selectedReviewConditions,
                selectedAttributeFilters: _selectedAttributeFilters,
                selectedBrand: _selectedBrand,
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
                selectedRtiMinimum: _selectedRtiMinimum,
                sortOption: _sortOption,
                onQuickFilterSelected: _handleQuickFilterSelected,
                onCategoryToggled: _toggleCategory,
                onPriceRangeToggled: _togglePriceRange,
                onReviewConditionToggled: _toggleReviewCondition,
                onAttributeToggled: _toggleAttributeFilter,
                onBrandSelected: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _currentPage = 1;
                  });
                },
                currentPage: _currentPage,
                pageSize: _pageSize,
                onPriceChanged: _handleManualPriceChanged,
                onRtiMinimumChanged: (value) {
                  setState(() {
                    _selectedRtiMinimum = value;
                    _isRtiFilterActive = true;
                    _currentPage = 1;
                  });
                },
                onSortChanged: (value) {
                  setState(() {
                    _sortOption = value;
                    _currentPage = 1;
                  });
                },
                onPageSelected: (page) => setState(() => _currentPage = page),
                onPageSizeChanged: (pageSize) {
                  setState(() {
                    _pageSize = pageSize;
                    _currentPage = 1;
                  });
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
      _currentPage = 1;
      switch (label) {
        case '전체':
          _sortOption = SearchSortOption.accuracy;
          _selectedRtiMinimum = 50;
          _isRtiFilterActive = false;
          break;
        case 'RTI 80+':
          _selectedRtiMinimum = 80;
          _isRtiFilterActive = true;
          break;
      }
    });
  }

  void _toggleCategory(String label) {
    setState(() {
      _toggleSetValue(_selectedCategories, label);
      _currentPage = 1;
    });
  }

  void _togglePriceRange(String label) {
    setState(() {
      if (_selectedPriceRanges.contains(label)) {
        _selectedPriceRanges.clear();
        _isPriceFilterActive = false;
        _lastPriceRangeQuery = null;
        _syncInitialPriceRange(
          mockSearchResultsFor(widget.query).products,
          widget.query,
        );
      } else {
        _selectedPriceRanges
          ..clear()
          ..add(label);
        final range = _priceRangeFor(label);
        _minPriceController.text = range.$1;
        _maxPriceController.text = range.$2;
        _isPriceFilterActive = true;
      }
      _currentPage = 1;
    });
  }

  void _handleManualPriceChanged() {
    setState(() {
      _selectedPriceRanges.clear();
      _isPriceFilterActive = true;
      _currentPage = 1;
    });
  }

  void _toggleReviewCondition(String label) {
    setState(() {
      _toggleSetValue(_selectedReviewConditions, label);
      _currentPage = 1;
    });
  }

  void _toggleAttributeFilter(String label) {
    setState(() {
      _toggleSetValue(_selectedAttributeFilters, label);
      _currentPage = 1;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories
        ..clear()
        ..add('이어폰');
      _selectedPriceRanges.clear();
      _isPriceFilterActive = false;
      _lastPriceRangeQuery = null;
      _syncInitialPriceRange(
        mockSearchResultsFor(widget.query).products,
        widget.query,
      );
      _selectedBrand = null;
      _selectedAttributeFilters.clear();
      _selectedReviewConditions
        ..clear()
        ..add('리뷰 50개 이상');
      _selectedQuickFilter = '전체';
      _sortOption = SearchSortOption.accuracy;
      _selectedRtiMinimum = 50;
      _isRtiFilterActive = false;
      _currentPage = 1;
      _pageSize = 60;
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

          if (_selectedBrand != null &&
              mockBrandFor(product) != _selectedBrand) {
            return false;
          }

          if (_selectedPriceRanges.isNotEmpty &&
              !_selectedPriceRanges.any(
                (range) => _matchesPriceRange(product, range),
              )) {
            return false;
          }

          if (_isPriceFilterActive) {
            final minPrice = _parsePrice(_minPriceController.text);
            final maxPrice = _parsePrice(_maxPriceController.text);
            if (minPrice != null && product.price < minPrice) {
              return false;
            }
            if (maxPrice != null && product.price > maxPrice) {
              return false;
            }
          }

          if (_isRtiFilterActive && product.avgRti < _selectedRtiMinimum) {
            return false;
          }

          if (_selectedAttributeFilters.isNotEmpty &&
              !_selectedAttributeFilters.every(
                (filter) => _matchesAttributeFilter(product, filter),
              )) {
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
      case SearchSortOption.sales:
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SearchSortOption.priceLow:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SearchSortOption.priceHigh:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SearchSortOption.newest:
        sorted.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    return sorted;
  }

  bool _matchesPriceRange(SearchResultProduct product, String label) {
    return switch (label) {
      '1만원 이하' => product.price <= 10000,
      '10~30만원' => product.price >= 100000 && product.price <= 300000,
      '30만원 이상' => product.price >= 300000,
      _ => true,
    };
  }

  (String, String) _priceRangeFor(String label) {
    return switch (label) {
      '1만원 이하' => ('0', '10000'),
      '10~30만원' => ('100000', '300000'),
      '30만원 이상' => ('300000', '700000'),
      _ => ('0', '700000'),
    };
  }

  int? _parsePrice(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }

    return int.tryParse(normalized);
  }

  void _syncInitialPriceRange(
    List<SearchResultProduct> products,
    String query,
  ) {
    if (_isPriceFilterActive || _lastPriceRangeQuery == query) {
      return;
    }

    _lastPriceRangeQuery = query;
    if (products.isEmpty) {
      _minPriceController.clear();
      _maxPriceController.clear();
      return;
    }

    final prices = products.map((product) => product.price);
    final minPrice = prices.reduce((value, element) {
      return value < element ? value : element;
    });
    final maxPrice = prices.reduce((value, element) {
      return value > element ? value : element;
    });

    _minPriceController.text = '$minPrice';
    _maxPriceController.text = '$maxPrice';
  }

  bool _matchesQuickFilter(SearchResultProduct product, String label) {
    return switch (label) {
      'RTI 80+' => product.avgRti >= 80,
      '아이폰 추천' => product.name.contains('아이오') || product.avgRti >= 80,
      '통화 품질 우수' => product.name.contains('통화') || product.avgRating >= 4.7,
      '무선' => product.name.contains('무선') || product.name.contains('Pods'),
      '노이즈캔슬링' => product.name.contains('ANC') || product.name.contains('노이즈'),
      '커널형' => product.name.contains('커널'),
      '오픈형' => product.name.contains('오픈') || product.id == 2,
      '스포츠/방수' => mockTraitChipsFor(product).contains('생활방수'),
      '게이밍' => mockTraitChipsFor(product).contains('저지연'),
      _ => true,
    };
  }

  bool _matchesAttributeFilter(SearchResultProduct product, String label) {
    final traits = mockTraitChipsFor(product);
    final badge = mockBadgeFor(product);

    return switch (label) {
      '무선' => product.name.contains('무선') || product.name.contains('Pods'),
      '커널형' => product.name.contains('커널'),
      '오픈형' => product.name.contains('오픈') || product.id == 2,
      '노이즈캔슬링' => product.name.contains('ANC') || product.name.contains('노이즈'),
      '통화 품질 우수' => product.name.contains('통화') || product.avgRating >= 4.7,
      '생활방수' => traits.contains('생활방수'),
      '저지연' => traits.contains('저지연'),
      '블루투스' => product.name.contains('블루투스') || product.name.contains('Pods'),
      'USB-C' => product.name.contains('USB-C') || product.id.isEven,
      '로켓배송/오늘출발' => badge == '오늘출발',
      '무료배송' => badge == '무료배송',
      '정기배송 가능' => product.id.isEven,
      '공식몰' => product.id == 3 || product.id == 4,
      '스토어' => product.id != 3 && product.id != 4,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useCompactHeader =
                context.isMobile || constraints.maxWidth < 1080;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                useCompactHeader ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xs,
                useCompactHeader ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xs,
              ),
              child: useCompactHeader
                  ? _MobileSearchHeader(
                      query: query,
                      onSearchSubmitted: onSearchSubmitted,
                    )
                  : _DesktopSearchHeader(
                      query: query,
                      onSearchSubmitted: onSearchSubmitted,
                    ),
            );
          },
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
          width: 440,
          child: Row(
            children: [
              HomeLogo(onTap: () => context.go(RoutePaths.home)),
              const SizedBox(width: AppSpacing.lg),
              _HeaderLink(label: '카테고리'),
              const SizedBox(width: AppSpacing.md),
              _HeaderLink(label: '랭킹'),
              const SizedBox(width: AppSpacing.md),
              _HeaderLink(label: '기획전'),
              const SizedBox(width: AppSpacing.md),
              _HeaderLink(label: '브랜드'),
              const SizedBox(width: AppSpacing.md),
              _HeaderLink(label: '리뷰 인사이트'),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 500,
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
        const SizedBox(height: AppSpacing.xs),
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
    final iconWidget = Icon(icon, size: 22, color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge == null
              ? iconWidget
              : Badge(label: Text(badge!), child: iconWidget),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
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
    required this.selectedAttributeFilters,
    required this.selectedBrand,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.sortOption,
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

    final useSingleColumn =
        context.isMobile || MediaQuery.sizeOf(context).width < 1080;

    if (useSingleColumn) {
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
            _SearchEmptyState(state: state)
          else ...[
            _FilterPanel(
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
            _ResultColumn(
              state: state,
              products: products,
              sortOption: sortOption,
              currentPage: currentPage,
              pageSize: pageSize,
              onSortChanged: onSortChanged,
              onPageSelected: onPageSelected,
              onPageSizeChanged: onPageSizeChanged,
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
          child: _FilterPanel(
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
              _SearchSummary(state: state),
              const SizedBox(height: AppSpacing.lg),
              _QuickFilterRow(
                filters: state.quickFilters,
                selectedFilter: selectedQuickFilter,
                onSelected: onQuickFilterSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isEmpty)
                _SearchEmptyState(state: state)
              else
                _ResultColumn(
                  state: state,
                  products: products,
                  sortOption: sortOption,
                  currentPage: currentPage,
                  pageSize: pageSize,
                  onSortChanged: onSortChanged,
                  onPageSelected: onPageSelected,
                  onPageSizeChanged: onPageSizeChanged,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: AppEmptyView(
        title: '검색 결과가 없어요',
        message: state.query.isEmpty
            ? '상품명이나 카테고리를 입력하면 리뷰 기반 추천 상품을 보여드려요.'
            : '다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.',
      ),
    );
  }
}

class _SearchSummary extends StatelessWidget {
  const _SearchSummary({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    final title = state.query.isEmpty ? '전체 상품' : state.query;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.isMobile ? 28 : 34,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                '검색 결과',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${_formatCount(state.displayTotalCount)}개 상품',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Re:view Trust Index(RTI)란?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              '실제 구매자 리뷰의 신뢰도를 종합해 산출한 지표입니다.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
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
              padding: const EdgeInsets.only(right: AppSpacing.xs),
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
    const selectedColor = Color(0xFF061332);
    final foreground = selected ? AppColors.onPrimary : AppColors.textPrimary;

    return Material(
      color: selected ? selectedColor : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minWidth: 84, minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? selectedColor : AppColors.borderStrong,
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
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
    required this.selectedAttributeFilters,
    required this.selectedBrand,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.resultCount,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onAttributeToggled,
    required this.onBrandSelected,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onResetFilters,
    this.compact = false,
  });

  final SearchResultsState state;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final Set<String> selectedAttributeFilters;
  final String? selectedBrand;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final int resultCount;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final ValueChanged<String> onAttributeToggled;
  final ValueChanged<String?> onBrandSelected;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final VoidCallback onResetFilters;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: const Color(0x080F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '필터',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onResetFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('초기화'),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
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
            const Divider(height: AppSpacing.lg),
            _FilterSection(
              title: '가격대',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RangeEndpoint(label: '${minPriceController.text}원'),
                    _RangeEndpoint(label: '${maxPriceController.text}원'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                _PriceRangeSlider(
                  products: state.products,
                  minPriceController: minPriceController,
                  maxPriceController: maxPriceController,
                  onChanged: onPriceChanged,
                ),
                const SizedBox(height: AppSpacing.sm),
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
            const Divider(height: AppSpacing.lg),
            _ExpandableFilterSection(
              title: '형태',
              children: [
                for (final label in const ['무선', '커널형', '오픈형'])
                  _CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _ExpandableFilterSection(
              title: '주요 기능',
              children: [
                for (final label in const ['노이즈캔슬링', '통화 품질 우수', '생활방수', '저지연'])
                  _CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _ExpandableFilterSection(
              title: '연결 방식',
              children: [
                for (final label in const ['블루투스', 'USB-C'])
                  _CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _ExpandableFilterSection(
              title: '브랜드',
              children: [
                _SelectBox(
                  label: selectedBrand ?? '브랜드를 선택하세요',
                  selectedBrand: selectedBrand,
                  onSelected: onBrandSelected,
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _FilterSection(
              title: 'RTI 신뢰 점수',
              trailing: '${selectedRtiMinimum.round()}점 이상',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _RangeEndpoint(label: '0%'),
                    _RangeEndpoint(label: '100%'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
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
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _PriceRangeChip(
                      label: '80% 이상',
                      selected: selectedRtiMinimum.round() == 80,
                      onPressed: () => onRtiMinimumChanged(80),
                    ),
                    _PriceRangeChip(
                      label: '90% 이상',
                      selected: selectedRtiMinimum.round() == 90,
                      onPressed: () => onRtiMinimumChanged(90),
                    ),
                    _PriceRangeChip(
                      label: '95% 이상',
                      selected: selectedRtiMinimum.round() == 95,
                      onPressed: () => onRtiMinimumChanged(95),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _FilterSection(
              title: '배송',
              children: [
                for (final label in const ['로켓배송/오늘출발', '무료배송', '정기배송 가능'])
                  _CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _FilterSection(
              title: '판매처 유형',
              children: [
                for (final label in const ['공식몰', '스토어'])
                  _CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
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
            const SizedBox(height: AppSpacing.md),
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

class _ExpandableFilterSection extends StatelessWidget {
  const _ExpandableFilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: AppSpacing.xs),
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
        iconColor: AppColors.textPrimary,
        collapsedIconColor: AppColors.textPrimary,
        children: children,
      ),
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
    return InkWell(
      onTap: onChanged,
      borderRadius: AppRadius.small,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            _FilterCheckboxMark(selected: selected),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterCheckboxMark extends StatelessWidget {
  const _FilterCheckboxMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderStrong,
          width: 1.4,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 10, color: AppColors.onPrimary)
          : null,
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
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) => onChanged(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
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
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _RangeEndpoint extends StatelessWidget {
  const _RangeEndpoint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 11,
      ),
    );
  }
}

class _PriceRangeSlider extends StatelessWidget {
  const _PriceRangeSlider({
    required this.products,
    required this.minPriceController,
    required this.maxPriceController,
    required this.onChanged,
  });

  final List<SearchResultProduct> products;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final bounds = _priceBounds(products);
    final minBound = bounds.$1.toDouble();
    final maxBound = bounds.$2.toDouble();
    final bins = _priceBins(products, bounds);
    final maxBin = bins.reduce((value, element) {
      return value > element ? value : element;
    });
    final currentMin =
        _parseControllerPrice(minPriceController.text) ?? bounds.$1;
    final currentMax =
        _parseControllerPrice(maxPriceController.text) ?? bounds.$2;
    final start = currentMin.clamp(bounds.$1, bounds.$2).toDouble();
    final end = currentMax.clamp(bounds.$1, bounds.$2).toDouble();
    final values = RangeValues(
      start <= end ? start : end,
      end >= start ? end : start,
    );

    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 8,
            right: 8,
            bottom: 13,
            child: KeyedSubtree(
              key: const ValueKey('price-histogram-bars'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var index = 0; index < bins.length; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: _PriceHistogramBar(
                          height: _barHeight(bins[index], maxBin),
                          active: _binOverlapsSelection(
                            index,
                            bins.length,
                            bounds,
                            values,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 9,
            child: Row(
              children: [
                for (var index = 0; index < bins.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color:
                              _binOverlapsSelection(
                                index,
                                bins.length,
                                bounds,
                                values,
                              )
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned.fill(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 0,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: AppColors.surface,
                overlayColor: AppColors.primary.withValues(alpha: 0.12),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 8,
                  elevation: 0,
                  pressedElevation: 0,
                ),
              ),
              child: RangeSlider(
                values: values,
                min: minBound,
                max: maxBound <= minBound ? minBound + 1 : maxBound,
                onChanged: (next) {
                  minPriceController.text = next.start.round().toString();
                  maxPriceController.text = next.end.round().toString();
                  onChanged();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> _priceBins(List<SearchResultProduct> products, (int, int) bounds) {
    const binCount = 18;
    final bins = List<int>.filled(binCount, 0);
    if (products.isEmpty) {
      return [1, 1, 2, 2, 4, 5, 7, 5, 4, 3, 3, 2, 2, 1, 1, 1, 1, 1];
    }

    final span = (bounds.$2 - bounds.$1).clamp(1, 1 << 31);
    for (final product in products) {
      final normalized = (product.price - bounds.$1) / span;
      final rawIndex = (normalized * (binCount - 1)).round();
      final index = rawIndex.clamp(0, binCount - 1);
      bins[index]++;
    }
    return bins;
  }

  double _barHeight(int count, int maxCount) {
    if (maxCount <= 0) {
      return 6;
    }
    return 5 + 18 * count / maxCount;
  }

  bool _binOverlapsSelection(
    int index,
    int binCount,
    (int, int) bounds,
    RangeValues values,
  ) {
    final span = bounds.$2 - bounds.$1;
    final binStart = bounds.$1 + span * index / binCount;
    final binEnd = bounds.$1 + span * (index + 1) / binCount;
    return binEnd >= values.start && binStart <= values.end;
  }

  (int, int) _priceBounds(List<SearchResultProduct> products) {
    if (products.isEmpty) {
      return (0, 700000);
    }

    final prices = products.map((product) => product.price);
    final minPrice = prices.reduce((value, element) {
      return value < element ? value : element;
    });
    final maxPrice = prices.reduce((value, element) {
      return value > element ? value : element;
    });

    return (minPrice, maxPrice == minPrice ? minPrice + 1 : maxPrice);
  }

  int? _parseControllerPrice(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return int.tryParse(normalized);
  }
}

class _PriceHistogramBar extends StatelessWidget {
  const _PriceHistogramBar({required this.height, required this.active});

  final double height;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.24)
              : AppColors.primaryLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.label,
    required this.selectedBrand,
    required this.onSelected,
  });

  final String label;
  final String? selectedBrand;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      tooltip: '브랜드 선택',
      initialValue: selectedBrand,
      onSelected: onSelected,
      color: AppColors.surface,
      elevation: 10,
      constraints: const BoxConstraints(minWidth: 210, maxWidth: 230),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String?>(
          value: null,
          height: 36,
          child: _SelectMenuItemLabel(
            label: '전체 브랜드',
            selected: selectedBrand == null,
          ),
        ),
        for (final brand in mockSearchBrands)
          PopupMenuItem<String?>(
            value: brand,
            height: 36,
            child: _SelectMenuItemLabel(
              label: brand,
              selected: selectedBrand == brand,
            ),
          ),
      ],
      child: _SelectControl(label: label, selected: selectedBrand != null),
    );
  }
}

class _SelectControl extends StatelessWidget {
  const _SelectControl({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFF),
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class _SelectMenuItemLabel extends StatelessWidget {
  const _SelectMenuItemLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        if (selected)
          const Icon(Icons.check, size: 15, color: AppColors.primary),
      ],
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
    required this.currentPage,
    required this.pageSize,
    required this.onSortChanged,
    required this.onPageSelected,
    required this.onPageSizeChanged,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final SearchSortOption sortOption;
  final int currentPage;
  final int pageSize;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSelected;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _ProductGrid.columnsForWidth(constraints.maxWidth);
        final totalPages = products.isEmpty
            ? 1
            : (products.length / pageSize).ceil();
        final activePage = currentPage < 1
            ? 1
            : currentPage > totalPages
            ? totalPages
            : currentPage;
        final pageStart = (activePage - 1) * pageSize;
        final pageEnd = pageStart + pageSize > products.length
            ? products.length
            : pageStart + pageSize;
        final pageProducts = products.sublist(pageStart, pageEnd);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (products.isNotEmpty && constraints.maxWidth >= 760) ...[
              _ReviewComparisonBanner(products: products),
              const SizedBox(height: AppSpacing.md),
            ],
            _ResultToolbar(
              resultCount: products.length,
              sortOption: sortOption,
              pageSize: pageSize,
              onSortChanged: onSortChanged,
              onPageSizeChanged: onPageSizeChanged,
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
              _ProductGrid(products: pageProducts, columns: columns),
              if (totalPages > 1) ...[
                const SizedBox(height: AppSpacing.lg),
                _Pagination(
                  currentPage: activePage,
                  totalPages: totalPages,
                  onPageSelected: onPageSelected,
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.columns});

  final List<SearchResultProduct> products;
  final int columns;

  static int columnsForWidth(double width) {
    return width >= 1500
        ? 5
        : width >= 1180
        ? 4
        : width >= 820
        ? 3
        : width >= 560
        ? 2
        : 1;
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = switch (columns) {
      1 => 460.0,
      2 => 410.0,
      3 => 388.0,
      4 => 372.0,
      _ => 360.0,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: cardHeight,
      ),
      itemBuilder: (context, index) {
        return _SearchProductCard(product: products[index]);
      },
    );
  }
}

class _ResultToolbar extends StatelessWidget {
  const _ResultToolbar({
    required this.resultCount,
    required this.sortOption,
    required this.pageSize,
    required this.onSortChanged,
    required this.onPageSizeChanged,
  });

  final int resultCount;
  final SearchSortOption sortOption;
  final int pageSize;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      SearchSortOption.accuracy,
      SearchSortOption.priceLow,
      SearchSortOption.rti,
      SearchSortOption.reviewCount,
      SearchSortOption.sales,
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            _SortSegmentedControl(
              options: options,
              selectedOption: sortOption,
              onChanged: onSortChanged,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$resultCount개 결과',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ViewModeButton(icon: Icons.grid_view_rounded, selected: true),
                _ViewModeButton(icon: Icons.view_list_rounded),
                const SizedBox(width: AppSpacing.xs),
                _PageSizeButton(
                  pageSize: pageSize,
                  onChanged: onPageSizeChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSegmentedControl extends StatelessWidget {
  const _SortSegmentedControl({
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  final List<SearchSortOption> options;
  final SearchSortOption selectedOption;
  final ValueChanged<SearchSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            '정렬',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in options)
                _SortSegment(
                  label: option.label,
                  selected: option == selectedOption,
                  onPressed: () => onChanged(option),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SortSegment extends StatelessWidget {
  const _SortSegment({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: selected ? AppColors.primaryLight : Colors.transparent,
        foregroundColor: selected ? AppColors.primary : AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        minimumSize: const Size(0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        textStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      child: Text(label, softWrap: false),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({required this.icon, this.selected = false});

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        onPressed: () {},
        style: IconButton.styleFrom(
          backgroundColor: selected
              ? AppColors.primaryLight
              : AppColors.surface,
          foregroundColor: selected
              ? AppColors.primary
              : AppColors.textSecondary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
        icon: Icon(icon, size: 17),
      ),
    );
  }
}

class _PageSizeButton extends StatelessWidget {
  const _PageSizeButton({required this.pageSize, required this.onChanged});

  final int pageSize;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const pageSizes = [30, 60, 120];

    return PopupMenuButton<int>(
      tooltip: '페이지당 상품 수',
      initialValue: pageSize,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final size in pageSizes)
          PopupMenuItem(
            value: size,
            child: _SelectMenuItemLabel(
              label: '$size개씩 보기',
              selected: size == pageSize,
            ),
          ),
      ],
      child: _SmallToolbarButton(
        label: '$pageSize개씩 보기',
        icon: Icons.keyboard_arrow_down_rounded,
      ),
    );
  }
}

class _SmallToolbarButton extends StatelessWidget {
  const _SmallToolbarButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _ReviewComparisonBanner extends StatelessWidget {
  const _ReviewComparisonBanner({required this.products});

  final List<SearchResultProduct> products;

  @override
  Widget build(BuildContext context) {
    final representative = _representativeProduct(products);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SizedBox(
          height: context.isMobile ? 260 : 206,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.surface,
                        AppColors.surface,
                        AppColors.primaryLight.withValues(alpha: 0.42),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: context.isMobile ? 220 : 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      representative.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(color: AppColors.surfaceMuted),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.surface,
                            AppColors.surface.withValues(alpha: 0.82),
                            AppColors.surface.withValues(alpha: 0.24),
                            AppColors.surface.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                right: context.isMobile ? 0 : 360,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.lg,
                        runSpacing: AppSpacing.sm,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '멀티 스토어 통합 검색',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          _BannerMetric(
                            icon: Icons.shopping_bag_outlined,
                            label: '비교 상품',
                            value: '${_formatCount(products.length)}개',
                          ),
                          _BannerMetric(
                            icon: Icons.chat_bubble_outline,
                            label: '수집 리뷰',
                            value:
                                '${_formatCount(representative.reviewCount)}건',
                          ),
                          _BannerMetric(
                            icon: Icons.favorite_border,
                            label: '평균 RTI',
                            value: '${representative.avgRti.round()}%',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '실사용 리뷰 기반 비교',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '가격과 리뷰, RTI 신뢰도를 한 번에 비교해 신뢰도 높은 상품을 빠르게 골라보세요.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: const [
                          _BannerFeature(
                            label: '최저가 비교',
                            icon: Icons.swap_vert,
                          ),
                          _BannerFeature(
                            label: '리뷰 신뢰도',
                            icon: Icons.verified_outlined,
                          ),
                          _BannerFeature(
                            label: '빠른 배송',
                            icon: Icons.local_shipping_outlined,
                          ),
                          _BannerFeature(
                            label: '공식몰 포함',
                            icon: Icons.workspace_premium_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SearchResultProduct _representativeProduct(
    List<SearchResultProduct> products,
  ) {
    return products.reduce((best, product) {
      return _representativeScore(product) > _representativeScore(best)
          ? product
          : best;
    });
  }

  double _representativeScore(SearchResultProduct product) {
    return product.avgRti * 2 +
        product.avgRating * 20 +
        product.reviewCount / 40;
  }
}

class _BannerMetric extends StatelessWidget {
  const _BannerMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FC).withValues(alpha: 0.88),
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: 46,
            child: Icon(icon, size: 24, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BannerFeature extends StatelessWidget {
  const _BannerFeature({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
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
            const SizedBox(height: AppSpacing.xs),
            Text(
              mockBrandFor(product),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              product.name,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                height: 1.22,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      product.avgRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '(리뷰 ${_formatCount(product.reviewCount)})',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                _DeliveryBadge(label: mockBadgeFor(product)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final chip in mockTraitChipsFor(product))
                  _ProductTraitChip(label: chip),
              ],
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatPrice(product.price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                _SquareIconButton(
                  icon: Icons.favorite_border,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                _SquareIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: _ProductDetailButton(onPressed: () {})),
              ],
            ),
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
        color: AppColors.surface.withValues(alpha: 0.82),
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
            Icon(Icons.verified_user_outlined, color: color, size: 14),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'RTI $value',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 12,
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
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _ProductTraitChip extends StatelessWidget {
  const _ProductTraitChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
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
      dimension: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: _outlineHoverButtonStyle(padding: EdgeInsets.zero),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _ProductDetailButton extends StatelessWidget {
  const _ProductDetailButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: _outlineHoverButtonStyle(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
        child: Text(
          '상품 상세 보기',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

ButtonStyle _outlineHoverButtonStyle({required EdgeInsetsGeometry padding}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all(padding),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primaryLight
          : AppColors.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primary
          : AppColors.textPrimary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      return BorderSide(
        color: states.contains(WidgetState.hovered)
            ? AppColors.primary
            : AppColors.borderStrong,
      );
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.small),
    ),
  );
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    final pages = List<int>.generate(totalPages, (index) => index + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageButton(
          icon: Icons.chevron_left,
          selected: false,
          enabled: currentPage > 1,
          onPressed: () => onPageSelected(currentPage - 1),
        ),
        for (final page in pages)
          _PageButton(
            label: '$page',
            selected: page == currentPage,
            enabled: true,
            onPressed: () => onPageSelected(page),
          ),
        _PageButton(
          icon: Icons.chevron_right,
          selected: false,
          enabled: currentPage < totalPages,
          onPressed: () => onPageSelected(currentPage + 1),
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    this.label,
    this.icon,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: SizedBox.square(
        dimension: 40,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
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
