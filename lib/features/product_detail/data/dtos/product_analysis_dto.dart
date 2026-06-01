import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductAnalysisDto {
  const ProductAnalysisDto({
    required this.productId,
    required this.averageRti,
    required this.level,
    required this.reviewCount,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.reviews,
  });

  final String productId;
  final double averageRti;
  final String level;
  final int reviewCount;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<ReviewAnalysisItemDto> reviews;

  factory ProductAnalysisDto.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['reviews'] as List? ?? [];
    return ProductAnalysisDto(
      productId: json['productId']?.toString() ?? '',
      averageRti: (json['averageRti'] as num?)?.toDouble() ?? 0.0,
      level: json['level'] as String? ?? 'safe',
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      safeCount: (json['safeCount'] as num?)?.toInt() ?? 0,
      warnCount: (json['warnCount'] as num?)?.toInt() ?? 0,
      dangerCount: (json['dangerCount'] as num?)?.toInt() ?? 0,
      reviews: rawReviews
          .map((e) => ReviewAnalysisItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<int, ReviewRtiDetail> toReviewRtiDetailMap() {
    final result = <int, ReviewRtiDetail>{};
    for (final item in reviews) {
      final id = int.tryParse(item.reviewId);
      if (id != null) {
        result[id] = item.toRtiDetail();
      }
    }
    return result;
  }
}

class ReviewAnalysisItemDto {
  const ReviewAnalysisItemDto({
    required this.reviewId,
    required this.rti,
    required this.level,
    required this.textScore,
    required this.behaviorScore,
    required this.networkScore,
    required this.reasons,
  });

  final String reviewId;
  final int rti;
  final String level;
  final int textScore;
  final int behaviorScore;
  final int networkScore;
  final List<ReviewReasonDto> reasons;

  factory ReviewAnalysisItemDto.fromJson(Map<String, dynamic> json) {
    final rawReasons = json['reasons'] as List? ?? [];
    return ReviewAnalysisItemDto(
      reviewId: json['reviewId']?.toString() ?? '',
      rti: (json['rti'] as num?)?.toInt() ?? 0,
      level: json['level'] as String? ?? 'safe',
      textScore: (json['textScore'] as num?)?.toInt() ?? 0,
      behaviorScore: (json['behaviorScore'] as num?)?.toInt() ?? 0,
      networkScore: (json['networkScore'] as num?)?.toInt() ?? 0,
      reasons: rawReasons
          .map((e) => ReviewReasonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ReviewRtiDetail toRtiDetail() {
    final color = _levelHexColor(level);
    final signals = [
      RtiSignal(
        label: '텍스트 신뢰도',
        score: textScore,
        iconType: 'text',
        color: color,
      ),
      RtiSignal(
        label: '행동 패턴',
        score: behaviorScore,
        iconType: 'behavior',
        color: color,
      ),
      RtiSignal(
        label: '네트워크 분석',
        score: networkScore,
        iconType: 'pattern',
        color: color,
      ),
    ];

    final bases = reasons
        .map(
          (r) => RtiJudgmentBasis(
            label: r.message,
            description: _codeToDescription(r.code),
            percentage: rti,
            iconType: _codeToIconType(r.code),
            color: color,
          ),
        )
        .toList();

    return ReviewRtiDetail(
      summaryDescription: _buildSummaryDescription(level, rti),
      summaryTags: _buildSummaryTags(level),
      signals: signals,
      judgmentBases: bases,
      sentenceHighlights: const [],
    );
  }

  static String _levelHexColor(String level) => switch (level.toLowerCase()) {
    'safe' => '#22C55E',
    'warn' || 'suspicious' => '#F59E0B',
    'danger' => '#EF4444',
    _ => '#6B7280',
  };

  static String _buildSummaryDescription(String level, int rti) =>
      switch (level.toLowerCase()) {
        'safe' =>
          'AI 분석 결과 신뢰도 높은 리뷰입니다. (RTI $rti)',
        'warn' || 'suspicious' =>
          'AI 분석 결과 일부 의심 신호가 감지된 리뷰입니다. (RTI $rti)',
        'danger' =>
          'AI 분석 결과 신뢰도가 낮은 리뷰입니다. (RTI $rti)',
        _ => 'AI 분석 결과입니다. (RTI $rti)',
      };

  static List<RtiSummaryTag> _buildSummaryTags(String level) =>
      switch (level.toLowerCase()) {
        'safe' => const [
          RtiSummaryTag(label: '신뢰 리뷰', type: RtiTagType.positive),
        ],
        'warn' || 'suspicious' => const [
          RtiSummaryTag(label: '의심 신호 감지', type: RtiTagType.info),
        ],
        'danger' => const [
          RtiSummaryTag(label: '위험 리뷰', type: RtiTagType.warning),
        ],
        _ => const [],
      };

  static String _codeToDescription(String code) => switch (code) {
    'NATURAL_TEXT' => '자연스러운 문체가 감지되었습니다.',
    'EXCESSIVE_EXCLAMATION' => '과도한 느낌표 사용 패턴이 감지되었습니다.',
    'REPETITIVE_PATTERN' => '반복적인 표현 패턴이 감지되었습니다.',
    'VERIFIED_PURCHASE' => '구매 인증이 확인된 리뷰입니다.',
    'ABNORMAL_TIMING' => '비정상적인 시점에 작성된 리뷰입니다.',
    'SIMILAR_CONTENT' => '다른 리뷰와 유사한 내용이 포함되어 있습니다.',
    'HIGH_STAR_ONLY' => '별점만 높고 내용이 부실한 리뷰입니다.',
    _ => code,
  };

  static String _codeToIconType(String code) => switch (code) {
    'NATURAL_TEXT' || 'HIGH_STAR_ONLY' || 'EXCESSIVE_EXCLAMATION' => 'context',
    'REPETITIVE_PATTERN' || 'SIMILAR_CONTENT' => 'repeat',
    'VERIFIED_PURCHASE' => 'history',
    'ABNORMAL_TIMING' => 'similarity',
    _ => 'context',
  };
}

class ReviewReasonDto {
  const ReviewReasonDto({required this.code, required this.message});

  final String code;
  final String message;

  factory ReviewReasonDto.fromJson(Map<String, dynamic> json) {
    return ReviewReasonDto(
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}
