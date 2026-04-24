import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';

class DashboardProductDto {
  const DashboardProductDto({
    required this.id,
    required this.name,
    required this.storeName,
    required this.price,
    required this.imageUrl,
    this.label,
    this.rating,
    this.reviewCount,
    this.rtiScore,
  });

  factory DashboardProductDto.fromJson(Map<String, dynamic> json) {
    return DashboardProductDto(
      id: _readString(json, ['id', 'productId', 'product_id']),
      name: _readString(json, ['name', 'productName', 'title']),
      storeName: _readString(json, [
        'storeName',
        'store',
        'brandName',
        'brand',
        'sellerName',
      ]),
      price: _readInt(json, ['price', 'salePrice', 'discountPrice']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      label: _readNullableString(json, ['label', 'badge', 'tag']),
      rating: _readDouble(json, ['rating', 'starRating', 'averageRating']),
      reviewCount: _readIntOrNull(json, [
        'reviewCount',
        'reviewsCount',
        'review_count',
      ]),
      rtiScore: _readIntOrNull(json, ['rtiScore', 'rti', 'trustScore']),
    );
  }

  final String id;
  final String name;
  final String storeName;
  final int price;
  final String imageUrl;
  final String? label;
  final double? rating;
  final int? reviewCount;
  final int? rtiScore;

  DashboardProduct toEntity() {
    return DashboardProduct(
      id: id,
      name: name,
      storeName: storeName,
      price: price,
      imageUrl: imageUrl,
      label: label,
      rating: rating,
      reviewCount: reviewCount,
      rtiScore: rtiScore,
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
  return _readIntOrNull(json, keys) ?? 0;
}

int? _readIntOrNull(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value.replaceAll(',', ''));
    }
  }
  return null;
}

double? _readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
  }
  return null;
}
