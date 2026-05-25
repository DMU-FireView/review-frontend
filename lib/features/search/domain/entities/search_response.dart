import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

class SearchResponse {
  const SearchResponse({
    required this.products,
    required this.totalCount,
  });

  final List<SearchResultProduct> products;
  final int totalCount;

  bool get isEmpty => products.isEmpty;
}
