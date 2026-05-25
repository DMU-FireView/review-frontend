import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/search/data/dtos/search_response_dto.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchResponseDto> searchProducts({required String query});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<SearchResponseDto> searchProducts({required String query}) async {
    final queryParameters = <String, dynamic>{
      if (query.isNotEmpty) 'keyword': query,
    };

    final response = await _apiClient.get(
      _config.searchPath,
      queryParameters: queryParameters,
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();

      if (body is List<dynamic>) {
        return SearchResponseDto.fromList(body);
      }
    }

    return const SearchResponseDto(products: []);
  }
}
