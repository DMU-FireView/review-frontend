import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';

class FeedbackItemDto {
  const FeedbackItemDto({
    required this.id,
    required this.typeLabel,
    required this.feedbackCategory,
    required this.status,
    required this.statusDescription,
    required this.productName,
    required this.reviewContent,
    required this.currentStep,
    required this.totalSteps,
    this.productId,
    this.createdAt,
  });

  factory FeedbackItemDto.fromJson(Map<String, dynamic> json) {
    return FeedbackItemDto(
      id: _readInt(json, ['id', 'feedbackId']),
      typeLabel: _readString(json, ['typeLabel', 'feedbackType', 'type']),
      feedbackCategory: _readString(json, ['feedbackCategory', 'category']),
      productId: _readNullableInt(json, ['productId', 'product_id']),
      status: _readString(json, ['status', 'feedbackStatus']),
      statusDescription: _readString(json, ['statusDescription', 'statusLabel']),
      productName: _readString(json, ['productName', 'product_name', 'name']),
      reviewContent: _readString(json, ['reviewContent', 'review_content', 'content']),
      currentStep: _readInt(json, ['currentStep', 'step']),
      totalSteps: _readInt(json, ['totalSteps']),
      createdAt: _readDateTime(json, ['createdAt', 'created_at', 'submittedAt']),
    );
  }

  static List<FeedbackItemDto> fromList(List<dynamic> list) =>
      list.whereType<Map<String, dynamic>>().map(FeedbackItemDto.fromJson).toList();

  final int id;
  final String typeLabel;
  final String feedbackCategory;
  final int? productId;
  final String status;
  final String statusDescription;
  final String productName;
  final String reviewContent;
  final int currentStep;
  final int totalSteps;
  final DateTime? createdAt;

  FeedbackItem toEntity() => FeedbackItem(
    id: id,
    typeLabel: typeLabel,
    feedbackCategory: feedbackCategory,
    productId: productId,
    status: status,
    statusDescription: statusDescription,
    productName: productName,
    reviewContent: reviewContent,
    currentStep: currentStep,
    totalSteps: totalSteps,
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
