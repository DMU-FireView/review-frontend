import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

enum SearchSortOption {
  accuracy(label: '정확도 순'),
  rti(label: 'RTI 높은순'),
  reviewCount(label: '리뷰 많은순'),
  sales(label: '판매 많은순'),
  priceLow(label: '최저가순'),
  priceHigh(label: '높은 가격순'),
  newest(label: '신상품순');

  const SearchSortOption({required this.label});

  final String label;
}

class SearchFilterChipData {
  const SearchFilterChipData({
    required this.label,
    required this.count,
    this.selected = false,
  });

  final String label;
  final int count;
  final bool selected;
}

class SearchResultsState {
  const SearchResultsState({
    required this.query,
    required this.products,
    required this.quickFilters,
    required this.categoryFilters,
    required this.priceRanges,
    this.totalCount,
    this.sortOption = SearchSortOption.accuracy,
    this.selectedRtiMinimum = 50,
    this.isLoading = false,
    this.errorMessage,
  });

  final String query;
  final List<SearchResultProduct> products;
  final List<SearchFilterChipData> quickFilters;
  final List<SearchFilterChipData> categoryFilters;
  final List<SearchFilterChipData> priceRanges;
  final int? totalCount;
  final SearchSortOption sortOption;
  final int selectedRtiMinimum;
  final bool isLoading;
  final String? errorMessage;

  int get displayTotalCount => totalCount ?? products.length;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => !isLoading && !hasError && products.isEmpty;
}
