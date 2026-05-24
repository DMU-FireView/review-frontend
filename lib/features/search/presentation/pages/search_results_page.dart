import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/data/mock_search_results.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_header.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_results_body.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

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
  SearchViewMode _viewMode = SearchViewMode.grid;
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
            child: SearchHeader(
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
              child: SearchResultsBody(
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
                viewMode: _viewMode,
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
                onViewModeChanged: (viewMode) {
                  setState(() => _viewMode = viewMode);
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
      _viewMode = SearchViewMode.grid;
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
