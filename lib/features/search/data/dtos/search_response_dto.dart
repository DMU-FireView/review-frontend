import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';

class SearchResponseDto {
  const SearchResponseDto({required this.products});

  factory SearchResponseDto.fromList(List<dynamic> list) {
    final products = list
        .whereType<Map<String, dynamic>>()
        .map(SearchResultProductDto.fromJson)
        .toList(growable: false);
    return SearchResponseDto(products: products);
  }

  final List<SearchResultProductDto> products;

  SearchResponse toEntity() {
    return SearchResponse(
      products: products.map((dto) => dto.toEntity()).toList(growable: false),
      totalCount: products.length,
    );
  }
}
