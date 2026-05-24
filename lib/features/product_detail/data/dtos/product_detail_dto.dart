import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';

class ProductDetailDto {
  const ProductDetailDto({
    required this.id,
    required this.name,
    required this.brand,
    required this.sellerName,
    required this.isOfficialSeller,
    required this.imageUrls,
    required this.price,
    required this.deliveryInfo,
    required this.category,
    required this.categoryDisplayName,
    required this.breadcrumbs,
    required this.avgRating,
    required this.reviewCount,
    required this.qaCount,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.specChips,
    required this.priceComparisons,
    required this.totalSellerCount,
    required this.rtiSummary,
    required this.trustSignals,
  });

  final int id;
  final String name;
  final String brand;
  final String sellerName;
  final bool isOfficialSeller;
  final List<String> imageUrls;
  final int price;
  final String deliveryInfo;
  final String category;
  final String categoryDisplayName;
  final List<String> breadcrumbs;
  final double avgRating;
  final int reviewCount;
  final int qaCount;
  final double avgRti;
  final String rtiGrade;
  final String rtiColor;
  final List<Map<String, dynamic>> specChips;
  final List<Map<String, dynamic>> priceComparisons;
  final int totalSellerCount;
  final Map<String, dynamic> rtiSummary;
  final List<Map<String, dynamic>> trustSignals;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) {
    return ProductDetailDto(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      sellerName: json['sellerName'] as String,
      isOfficialSeller: json['isOfficialSeller'] as bool,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      price: json['price'] as int,
      deliveryInfo: json['deliveryInfo'] as String,
      category: json['category'] as String,
      categoryDisplayName: json['categoryDisplayName'] as String,
      breadcrumbs: List<String>.from(json['breadcrumbs'] as List),
      avgRating: (json['avgRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      qaCount: json['qaCount'] as int,
      avgRti: (json['avgRti'] as num).toDouble(),
      rtiGrade: json['rtiGrade'] as String,
      rtiColor: json['rtiColor'] as String,
      specChips: List<Map<String, dynamic>>.from(json['specChips'] as List),
      priceComparisons: List<Map<String, dynamic>>.from(
        json['priceComparisons'] as List,
      ),
      totalSellerCount: json['totalSellerCount'] as int,
      rtiSummary: json['rtiSummary'] as Map<String, dynamic>,
      trustSignals: List<Map<String, dynamic>>.from(
        json['trustSignals'] as List,
      ),
    );
  }

  ProductDetail toEntity() {
    return ProductDetail(
      id: id,
      name: name,
      brand: brand,
      sellerName: sellerName,
      isOfficialSeller: isOfficialSeller,
      imageUrls: imageUrls,
      price: price,
      deliveryInfo: deliveryInfo,
      category: category,
      categoryDisplayName: categoryDisplayName,
      breadcrumbs: breadcrumbs,
      avgRating: avgRating,
      reviewCount: reviewCount,
      qaCount: qaCount,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      specChips: specChips.map((m) => ProductSpecChip(
        label: m['label'] as String,
        subtitle: m['subtitle'] as String,
        iconData: m['iconData'] as String,
      )).toList(),
      priceComparisons: priceComparisons.map((m) => PriceComparison(
        sellerName: m['sellerName'] as String,
        sellerLogoTag: m['sellerLogoTag'] as String,
        price: m['price'] as int,
        deliveryInfo: m['deliveryInfo'] as String,
        isLowest: m['isLowest'] as bool,
        isOfficial: m['isOfficial'] as bool,
        linkLabel: m['linkLabel'] as String,
      )).toList(),
      totalSellerCount: totalSellerCount,
      rtiSummary: RtiSummary(
        rtiScore: rtiSummary['rtiScore'] as int,
        rtiLabel: rtiSummary['rtiLabel'] as String,
        rtiSubLabel: rtiSummary['rtiSubLabel'] as String,
        realReviewRatio: (rtiSummary['realReviewRatio'] as num).toDouble(),
        realReviewLabel: rtiSummary['realReviewLabel'] as String,
        adSuspicionRatio: (rtiSummary['adSuspicionRatio'] as num).toDouble(),
        adSuspicionLabel: rtiSummary['adSuspicionLabel'] as String,
        repetitionRatio: (rtiSummary['repetitionRatio'] as num).toDouble(),
        repetitionLabel: rtiSummary['repetitionLabel'] as String,
        summaryMessage: rtiSummary['summaryMessage'] as String,
        analyzedReviewCount: rtiSummary['analyzedReviewCount'] as int,
      ),
      trustSignals: trustSignals.map((m) => TrustSignal(
        label: m['label'] as String,
        value: m['value'] as String,
        isPositive: m['isPositive'] as bool,
      )).toList(),
    );
  }
}

class ProductReviewDto {
  const ProductReviewDto({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.platform,
    required this.isVerifiedPurchase,
    required this.rtiScore,
    required this.rtiColor,
    required this.rtiLabel,
    required this.imageUrls,
  });

  final int id;
  final String authorName;
  final String? authorAvatarUrl;
  final double rating;
  final String content;
  final String createdAt;
  final String platform;
  final bool isVerifiedPurchase;
  final int rtiScore;
  final String rtiColor;
  final String rtiLabel;
  final List<String> imageUrls;

  factory ProductReviewDto.fromJson(Map<String, dynamic> json) {
    return ProductReviewDto(
      id: json['id'] as int,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      platform: json['platform'] as String,
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool,
      rtiScore: json['rtiScore'] as int,
      rtiColor: json['rtiColor'] as String,
      rtiLabel: json['rtiLabel'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
    );
  }

  ProductReview toEntity() {
    return ProductReview(
      id: id,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      rating: rating,
      content: content,
      createdAt: createdAt,
      platform: platform,
      isVerifiedPurchase: isVerifiedPurchase,
      rtiScore: rtiScore,
      rtiColor: rtiColor,
      rtiLabel: rtiLabel,
      imageUrls: imageUrls,
    );
  }
}

class ReviewInsightDto {
  const ReviewInsightDto({
    required this.keywords,
    required this.satisfactionPoints,
    required this.dissatisfactionPoints,
  });

  final List<Map<String, dynamic>> keywords;
  final List<String> satisfactionPoints;
  final List<String> dissatisfactionPoints;

  factory ReviewInsightDto.fromJson(Map<String, dynamic> json) {
    return ReviewInsightDto(
      keywords: List<Map<String, dynamic>>.from(json['keywords'] as List),
      satisfactionPoints: List<String>.from(
        json['satisfactionPoints'] as List,
      ),
      dissatisfactionPoints: List<String>.from(
        json['dissatisfactionPoints'] as List,
      ),
    );
  }

  ReviewInsight toEntity() {
    return ReviewInsight(
      keywords: keywords.map((m) => ReviewKeyword(
        label: m['label'] as String,
        count: m['count'] as int,
      )).toList(),
      satisfactionPoints: satisfactionPoints,
      dissatisfactionPoints: dissatisfactionPoints,
    );
  }
}

class SimilarProductDto {
  const SimilarProductDto({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.avgRating,
    required this.reviewCount,
    required this.avgRti,
    required this.rtiColor,
  });

  final int id;
  final String name;
  final String brand;
  final String imageUrl;
  final int price;
  final double avgRating;
  final int reviewCount;
  final double avgRti;
  final String rtiColor;

  factory SimilarProductDto.fromJson(Map<String, dynamic> json) {
    return SimilarProductDto(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      imageUrl: json['imageUrl'] as String,
      price: json['price'] as int,
      avgRating: (json['avgRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      avgRti: (json['avgRti'] as num).toDouble(),
      rtiColor: json['rtiColor'] as String,
    );
  }

  SimilarProduct toEntity() {
    return SimilarProduct(
      id: id,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      price: price,
      avgRating: avgRating,
      reviewCount: reviewCount,
      avgRti: avgRti,
      rtiColor: rtiColor,
    );
  }
}
