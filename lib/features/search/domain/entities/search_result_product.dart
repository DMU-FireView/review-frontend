class SearchResultProduct {
  const SearchResultProduct({
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

  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String categoryDisplayName;
  final String? platform;
  final double avgRti;
  final String rtiGrade;
  final String rtiColor;
  final int reviewCount;
  final double avgRating;
}
