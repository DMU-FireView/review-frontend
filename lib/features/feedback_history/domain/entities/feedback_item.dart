class FeedbackItem {
  const FeedbackItem({
    required this.id,
    required this.reviewId,
    required this.feedbackType,
    required this.status,
    required this.productName,
    required this.reviewContent,
    this.productId,
    this.createdAt,
  });

  final int id;
  final int reviewId;
  final int? productId;
  final String feedbackType;
  final String status;
  final String productName;
  final String reviewContent;
  final DateTime? createdAt;
}
