import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';

abstract interface class SearchRepository {
  Future<Result<SearchResponse>> searchProducts(SearchParams params);
}
