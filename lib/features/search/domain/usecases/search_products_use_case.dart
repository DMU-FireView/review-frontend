import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';

class SearchParams {
  const SearchParams({required this.query});

  final String query;
}

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final SearchRepository _repository;

  Future<Result<SearchResponse>> call(SearchParams params) =>
      _repository.searchProducts(params);
}
