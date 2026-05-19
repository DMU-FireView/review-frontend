import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

enum SearchSortOption {
  relevance(label: '관련도순'),
  rti(label: 'RTI 높은순'),
  reviewCount(label: '리뷰 많은순'),
  priceLow(label: '낮은 가격순');

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
    required this.filters,
    this.sortOption = SearchSortOption.relevance,
    this.isLoading = false,
    this.errorMessage,
  });

  final String query;
  final List<SearchResultProduct> products;
  final List<SearchFilterChipData> filters;
  final SearchSortOption sortOption;
  final bool isLoading;
  final String? errorMessage;

  int get totalCount => products.length;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => !isLoading && !hasError && products.isEmpty;
}
