import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';

class TrendingKeywordDto {
  const TrendingKeywordDto({required this.keyword, required this.rank});

  factory TrendingKeywordDto.fromJson(
    Map<String, dynamic> json, {
    required int fallbackRank,
  }) {
    return TrendingKeywordDto(
      keyword:
          json['keyword']?.toString() ??
          json['name']?.toString() ??
          json['text']?.toString() ??
          '',
      rank: _readRank(json) ?? fallbackRank,
    );
  }

  factory TrendingKeywordDto.fromValue(Object? value, {required int rank}) {
    if (value is Map<String, dynamic>) {
      return TrendingKeywordDto.fromJson(value, fallbackRank: rank);
    }

    return TrendingKeywordDto(keyword: value?.toString() ?? '', rank: rank);
  }

  final String keyword;
  final int rank;

  TrendingKeyword toEntity() => TrendingKeyword(keyword: keyword, rank: rank);
}

int? _readRank(Map<String, dynamic> json) {
  final value = json['rank'] ?? json['order'] ?? json['position'];
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
