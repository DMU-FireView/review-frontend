import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';

class FeedbackItemDto {
  const FeedbackItemDto({
    required this.id,
    required this.reviewId,
    required this.feedbackType,
    required this.status,
    required this.productName,
    required this.reviewContent,
    this.productId,
    this.createdAt,
  });

  factory FeedbackItemDto.fromJson(Map<String, dynamic> json) {
    return FeedbackItemDto(
      id: _readInt(json, ['id', 'feedbackId']),
      reviewId: _readInt(json, ['reviewId', 'review_id']),
      productId: _readNullableInt(json, ['productId', 'product_id']),
      feedbackType: _readString(json, ['feedbackType', 'type']),
      status: _readString(json, ['status', 'feedbackStatus']),
      productName: _readString(json, ['productName', 'product_name', 'name']),
      reviewContent: _readString(json, ['reviewContent', 'review_content', 'content']),
      createdAt: _readDateTime(json, ['createdAt', 'created_at', 'submittedAt']),
    );
  }

  static List<FeedbackItemDto> fromList(List<dynamic> list) =>
      list.whereType<Map<String, dynamic>>().map(FeedbackItemDto.fromJson).toList();

  final int id;
  final int reviewId;
  final int? productId;
  final String feedbackType;
  final String status;
  final String productName;
  final String reviewContent;
  final DateTime? createdAt;

  FeedbackItem toEntity() => FeedbackItem(
    id: id,
    reviewId: reviewId,
    productId: productId,
    feedbackType: feedbackType,
    status: status,
    productName: productName,
    reviewContent: reviewContent,
    createdAt: createdAt,
  );
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return '';
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

int? _readNullableInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
  }
  return null;
}

DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
  }
  return null;
}
