class ReviewInsight {
  const ReviewInsight({
    required this.keywords,
    required this.satisfactionPoints,
    required this.dissatisfactionPoints,
  });

  final List<ReviewKeyword> keywords;
  final List<String> satisfactionPoints;
  final List<String> dissatisfactionPoints;
}

class ReviewKeyword {
  const ReviewKeyword({required this.label, required this.count});

  final String label;
  final int count;
}
