import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

class SearchResultProductDto {
  const SearchResultProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.categoryDisplayName,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.reviewCount,
    required this.avgRating,
    this.platform,
  });

  factory SearchResultProductDto.fromJson(Map<String, dynamic> json) {
    return SearchResultProductDto(
      id: _readInt(json, ['id', 'productId']),
      name: _readString(json, ['name', 'productName', 'title']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      price: _readInt(json, ['price', 'salePrice', 'discountPrice']),
      category: _readString(json, ['category', 'categoryCode']),
      categoryDisplayName: _readString(json, [
        'categoryDisplayName',
        'categoryName',
        'category',
      ]),
      avgRti: _readDouble(json, ['avgRti', 'rtiScore', 'rti']) ?? 0.0,
      rtiGrade: _readString(json, ['rtiGrade', 'grade']),
      rtiColor: _readString(json, ['rtiColor', 'color']),
      reviewCount: _readInt(json, ['reviewCount', 'review_count']),
      avgRating:
          _readDouble(json, ['avgRating', 'rating', 'starRating']) ?? 0.0,
      platform: _readNullableString(json, [
        'platform',
        'storeName',
        'brandName',
      ]),
    );
  }

  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String categoryDisplayName;
  final double avgRti;
  final String rtiGrade;
  final String rtiColor;
  final int reviewCount;
  final double avgRating;
  final String? platform;

  SearchResultProduct toEntity() {
    final normalizedDisplayName = normalizedCategoryLabel(
      category: category,
      categoryDisplayName: categoryDisplayName,
      productName: name,
    );

    return SearchResultProduct(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      category: category,
      categoryDisplayName: normalizedDisplayName,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      reviewCount: reviewCount,
      avgRating: avgRating,
      platform: platform,
    );
  }
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  return _readNullableString(json, keys) ?? '';
}

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return null;
}

int _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
  }
  return 0;
}

double? _readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
  }
  return null;
}
