/// 분석 피드백(RTI 이의 제기) 처리 상태.
enum AnalysisFeedbackStatus {
  submitted('SUBMITTED', '접수'),
  underReview('UNDER_REVIEW', '검토 중'),
  resolved('RESOLVED', '처리 완료'),
  rejected('REJECTED', '반려');

  const AnalysisFeedbackStatus(this.code, this.label);

  final String code;
  final String label;

  static AnalysisFeedbackStatus? fromCode(String? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// 사용자의 신뢰 판단(userJudgment) 표시용 라벨 매핑.
String analysisUserJudgmentLabel(String? code) => switch (code) {
      'MORE_TRUSTWORTHY' => '신뢰도가 더 높아요',
      'MORE_RISKY' => '위험도가 더 높아요',
      'UNDECIDED' => '판단 보류',
      _ => '-',
    };

/// 관리자 검수용 분석 피드백 항목.
class AdminAnalysisFeedback {
  const AdminAnalysisFeedback({
    required this.feedbackId,
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    required this.feedbackType,
    required this.feedbackTypeDescription,
    required this.userJudgment,
    required this.relatedSignals,
    required this.detail,
    required this.attachmentUrl,
    required this.replyEmail,
    required this.status,
    required this.statusDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  final int feedbackId;
  final int reviewId;
  final String productName;
  final String reviewContent;
  final String feedbackType;
  final String feedbackTypeDescription;
  final String? userJudgment;
  final List<String> relatedSignals;
  final String? detail;
  final String? attachmentUrl;
  final String? replyEmail;
  final AnalysisFeedbackStatus? status;
  final String statusDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get userJudgmentLabel => analysisUserJudgmentLabel(userJudgment);

  AdminAnalysisFeedback copyWith({
    AnalysisFeedbackStatus? status,
    String? statusDescription,
    DateTime? updatedAt,
  }) {
    return AdminAnalysisFeedback(
      feedbackId: feedbackId,
      reviewId: reviewId,
      productName: productName,
      reviewContent: reviewContent,
      feedbackType: feedbackType,
      feedbackTypeDescription: feedbackTypeDescription,
      userJudgment: userJudgment,
      relatedSignals: relatedSignals,
      detail: detail,
      attachmentUrl: attachmentUrl,
      replyEmail: replyEmail,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
