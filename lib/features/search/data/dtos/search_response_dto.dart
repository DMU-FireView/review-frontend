import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';

class SearchResponseDto {
  const SearchResponseDto({required this.products, this.totalCount});

  factory SearchResponseDto.fromList(List<dynamic> list) {
    final products = list
        .whereType<Map<String, dynamic>>()
        .map(SearchResultProductDto.fromJson)
        .toList(growable: false);
    return SearchResponseDto(products: products);
  }

  factory SearchResponseDto.fromListWithTotal(
    List<dynamic> list,
    int? totalCount,
  ) {
    final products = list
        .whereType<Map<String, dynamic>>()
        .map(SearchResultProductDto.fromJson)
        .toList(growable: false);
    return SearchResponseDto(products: products, totalCount: totalCount);
  }

  final List<SearchResultProductDto> products;
  final int? totalCount;

  SearchResponse toEntity() {
    return SearchResponse(
      products: products.map((dto) => dto.toEntity()).toList(growable: false),
      totalCount: totalCount ?? products.length,
    );
  }
}
