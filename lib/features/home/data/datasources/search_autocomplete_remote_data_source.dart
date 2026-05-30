import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

abstract class SearchAutocompleteRemoteDataSource {
  Future<List<String>> fetchSuggestions(String query);
}

class GoogleSearchAutocompleteRemoteDataSource
    implements SearchAutocompleteRemoteDataSource {
  GoogleSearchAutocompleteRemoteDataSource({required Dio dio}) : _dio = dio;

  static const _codetabsProxyHost = 'api.codetabs.com';
  static const _codetabsProxyPath = '/v1/proxy';
  static const _proxyHost = 'api.allorigins.win';
  static const _proxyPath = '/raw';
  static const _googleHost = 'suggestqueries.google.com';
  static const _googlePath = '/complete/search';

  final Dio _dio;
  final _cache = <String, List<String>>{};

  @override
  Future<List<String>> fetchSuggestions(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const [];
    }
    final cached = _cache[trimmedQuery];
    if (cached != null) {
      return cached;
    }

    final googleUri = Uri.https(_googleHost, _googlePath, {
      'client': 'firefox',
      'hl': 'ko',
      'ie': 'utf-8',
      'oe': 'utf-8',
      'q': trimmedQuery,
    });
    final proxyUris = [
      Uri.https(_codetabsProxyHost, _codetabsProxyPath, {
        'quest': googleUri.toString(),
      }),
      Uri.https(_proxyHost, _proxyPath, {'url': googleUri.toString()}),
    ];

    for (final proxyUri in proxyUris) {
      try {
        final response = await _dio.getUri<String>(
          proxyUri,
          options: Options(
            responseType: ResponseType.plain,
            sendTimeout: const Duration(seconds: 2),
            receiveTimeout: const Duration(seconds: 3),
          ),
        );
        final suggestions = _parseSuggestions(response.data);
        _cache[trimmedQuery] = suggestions;
        return suggestions;
      } on DioException {
        continue;
      } on FormatException {
        continue;
      }
    }

    return const [];
  }

  List<String> _parseSuggestions(String? responseBody) {
    final decoded = jsonDecode(responseBody ?? '');
    if (decoded is! List || decoded.length < 2 || decoded[1] is! List) {
      return const [];
    }

    return (decoded[1] as List)
        .whereType<String>()
        .map((suggestion) => suggestion.trim())
        .where((suggestion) => suggestion.isNotEmpty)
        .toSet()
        .take(6)
        .toList(growable: false);
  }
}
