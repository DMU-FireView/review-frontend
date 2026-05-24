class SimilarProduct {
  const SimilarProduct({
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
}
