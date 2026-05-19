class SearchResultProduct {
  const SearchResultProduct({
    required this.id,
    required this.name,
    required this.storeName,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.rtiScore,
    required this.imageUrl,
    required this.summary,
    this.originalPrice,
    this.badge,
  });

  final String id;
  final String name;
  final String storeName;
  final String category;
  final int price;
  final int? originalPrice;
  final double rating;
  final int reviewCount;
  final int rtiScore;
  final String imageUrl;
  final String summary;
  final String? badge;
}
