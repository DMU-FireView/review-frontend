class DashboardProduct {
  const DashboardProduct({
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

  final String id;
  final String name;
  final String storeName;
  final int price;
  final String imageUrl;
  final String? label;
  final double? rating;
  final int? reviewCount;
  final int? rtiScore;
}
