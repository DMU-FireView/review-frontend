import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';

ProductDetail mockProductDetailFor(int id) {
  return switch (id) {
    2 => _mockProduct2,
    3 => _mockProduct3,
    _ => _mockProduct1,
  };
}

List<ProductReview> mockReviewsFor(int productId) => _mockReviews;

ReviewInsight mockInsightFor(int productId) => _mockInsight;

List<SimilarProduct> mockSimilarProductsFor(int productId) =>
    _mockSimilarProducts;

const _mockProduct1 = ProductDetail(
  id: 1,
  name: 'AeroFit ANC 무선 블루투스 이어폰\n노이즈캔슬링',
  brand: 'SoundBloom',
  sellerName: 'SoundBloom',
  isOfficialSeller: true,
  imageUrls: [
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&w=800&q=80',
  ],
  price: 89000,
  deliveryInfo: '무료배송 · 오늘출발',
  category: 'ELECTRONICS',
  categoryDisplayName: '이어폰',
  breadcrumbs: ['홈', '음향기기', '이어폰', 'ANC 블루투스 이어폰'],
  avgRating: 4.3,
  reviewCount: 24871,
  qaCount: 312,
  avgRti: 92,
  rtiGrade: 'SAFE',
  rtiColor: '#22C55E',
  specChips: [
    ProductSpecChip(label: 'ANC', subtitle: '액티브 노이즈 캔슬링', iconData: 'noise'),
    ProductSpecChip(label: '멀티포인트', subtitle: '2대 유시 연결', iconData: 'bluetooth'),
    ProductSpecChip(label: '블루투스 5.4', subtitle: '최신 버전', iconData: 'bluetooth'),
    ProductSpecChip(label: '생활방수', subtitle: 'IPX4 등급', iconData: 'water'),
    ProductSpecChip(label: '통화 품질 향상', subtitle: 'AI ENC 적용', iconData: 'call'),
    ProductSpecChip(label: '최대 28시간', subtitle: '충전케이스 포함', iconData: 'battery'),
  ],
  priceComparisons: [
    PriceComparison(
      sellerName: '쿠팡',
      sellerLogoTag: 'coupang',
      price: 89000,
      deliveryInfo: '무료배송·오늘출발',
      isLowest: true,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
    PriceComparison(
      sellerName: '네이버쇼핑',
      sellerLogoTag: 'naver',
      price: 89900,
      deliveryInfo: '무료배송·내일도착',
      isLowest: false,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
    PriceComparison(
      sellerName: '11번가',
      sellerLogoTag: '11st',
      price: 91900,
      deliveryInfo: '무료배송·오늘출발',
      isLowest: false,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
    PriceComparison(
      sellerName: '공식몰',
      sellerLogoTag: 'official',
      price: 99000,
      deliveryInfo: '무료배송',
      isLowest: false,
      isOfficial: true,
      linkLabel: '공식몰 보기',
    ),
  ],
  totalSellerCount: 18,
  rtiSummary: RtiSummary(
    rtiScore: 92,
    rtiLabel: '높음',
    rtiSubLabel: '상위 12% 수준',
    realReviewRatio: 0.87,
    realReviewLabel: '높음',
    adSuspicionRatio: 0.06,
    adSuspicionLabel: '낮음',
    repetitionRatio: 0.07,
    repetitionLabel: '낮음',
    summaryMessage: '구매 인증, 다양한 사용 경험, 자연스러운 표현이 많은 신뢰도 높은 리뷰입니다.',
    analyzedReviewCount: 24871,
  ),
  trustSignals: [
    TrustSignal(label: '구매인증 리뷰 비율', value: '높음', isPositive: true),
    TrustSignal(label: '텍스트 다양성', value: '높음', isPositive: true),
    TrustSignal(label: '반복 표현 비율', value: '낮음', isPositive: true),
    TrustSignal(label: '작성 시점 패턴 자연스러움', value: '자연스러움', isPositive: true),
  ],
);

const _mockProduct2 = ProductDetail(
  id: 2,
  name: '이어온 QuietBuds Lite ANC\n커널형 무선',
  brand: 'Modern Audio',
  sellerName: '이어온 공식스토어',
  isOfficialSeller: false,
  imageUrls: [
    'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=800&q=80',
  ],
  price: 62500,
  deliveryInfo: '무료배송 · 내일 도착',
  category: 'ELECTRONICS',
  categoryDisplayName: '이어폰',
  breadcrumbs: ['홈', '음향기기', '이어폰', 'ANC 블루투스 이어폰'],
  avgRating: 4.5,
  reviewCount: 892,
  qaCount: 78,
  avgRti: 63,
  rtiGrade: 'SUSPICIOUS',
  rtiColor: '#F97316',
  specChips: [
    ProductSpecChip(label: 'ANC', subtitle: '하이브리드 노이즈 캔슬링', iconData: 'noise'),
    ProductSpecChip(label: '커널형', subtitle: '밀폐형 이어팁', iconData: 'earphone'),
    ProductSpecChip(label: '블루투스 5.3', subtitle: '안정적 연결', iconData: 'bluetooth'),
    ProductSpecChip(label: '최대 24시간', subtitle: '케이스 포함', iconData: 'battery'),
  ],
  priceComparisons: [
    PriceComparison(
      sellerName: '쿠팡',
      sellerLogoTag: 'coupang',
      price: 62500,
      deliveryInfo: '무료배송·오늘출발',
      isLowest: true,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
    PriceComparison(
      sellerName: '네이버쇼핑',
      sellerLogoTag: 'naver',
      price: 63900,
      deliveryInfo: '무료배송',
      isLowest: false,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
  ],
  totalSellerCount: 9,
  rtiSummary: RtiSummary(
    rtiScore: 63,
    rtiLabel: '주의',
    rtiSubLabel: '상위 47% 수준',
    realReviewRatio: 0.62,
    realReviewLabel: '보통',
    adSuspicionRatio: 0.21,
    adSuspicionLabel: '보통',
    repetitionRatio: 0.19,
    repetitionLabel: '보통',
    summaryMessage: '일부 광고성 의심 표현과 반복 표현이 확인됩니다. 리뷰를 꼼꼼히 살펴보세요.',
    analyzedReviewCount: 892,
  ),
  trustSignals: [
    TrustSignal(label: '구매인증 리뷰 비율', value: '보통', isPositive: false),
    TrustSignal(label: '텍스트 다양성', value: '보통', isPositive: false),
    TrustSignal(label: '반복 표현 비율', value: '보통', isPositive: false),
    TrustSignal(label: '작성 시점 패턴 자연스러움', value: '다소 부자연스러움', isPositive: false),
  ],
);

const _mockProduct3 = ProductDetail(
  id: 3,
  name: 'XY Pro 초경량 ANC 블루투스\n이어폰 2026 신형',
  brand: 'Daily Gadget',
  sellerName: 'XY 공식스토어',
  isOfficialSeller: true,
  imageUrls: [
    'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80',
  ],
  price: 39900,
  deliveryInfo: '무료배송 · 오늘출발',
  category: 'ELECTRONICS',
  categoryDisplayName: '이어폰',
  breadcrumbs: ['홈', '음향기기', '이어폰', 'ANC 블루투스 이어폰'],
  avgRating: 4.7,
  reviewCount: 2104,
  qaCount: 124,
  avgRti: 38,
  rtiGrade: 'DANGER',
  rtiColor: '#EF4444',
  specChips: [
    ProductSpecChip(label: 'ANC', subtitle: '디지털 노이즈 캔슬링', iconData: 'noise'),
    ProductSpecChip(label: '초경량', subtitle: '4.5g 이하', iconData: 'weight'),
    ProductSpecChip(label: '블루투스 5.3', subtitle: '', iconData: 'bluetooth'),
    ProductSpecChip(label: '최대 20시간', subtitle: '케이스 포함', iconData: 'battery'),
  ],
  priceComparisons: [
    PriceComparison(
      sellerName: '쿠팡',
      sellerLogoTag: 'coupang',
      price: 39900,
      deliveryInfo: '무료배송·오늘출발',
      isLowest: true,
      isOfficial: false,
      linkLabel: '최저가 보기',
    ),
  ],
  totalSellerCount: 5,
  rtiSummary: RtiSummary(
    rtiScore: 38,
    rtiLabel: '위험',
    rtiSubLabel: '하위 15% 수준',
    realReviewRatio: 0.31,
    realReviewLabel: '낮음',
    adSuspicionRatio: 0.48,
    adSuspicionLabel: '높음',
    repetitionRatio: 0.52,
    repetitionLabel: '높음',
    summaryMessage: '광고성 및 반복 표현이 많이 확인됩니다. 실제 구매 전 주의가 필요합니다.',
    analyzedReviewCount: 2104,
  ),
  trustSignals: [
    TrustSignal(label: '구매인증 리뷰 비율', value: '낮음', isPositive: false),
    TrustSignal(label: '텍스트 다양성', value: '낮음', isPositive: false),
    TrustSignal(label: '반복 표현 비율', value: '높음', isPositive: false),
    TrustSignal(label: '작성 시점 패턴 자연스러움', value: '부자연스러움', isPositive: false),
  ],
);

const _mockReviews = [
  ProductReview(
    id: 1,
    authorName: '김*현',
    authorAvatarUrl: null,
    rating: 5.0,
    content:
        '이 가격에 이 정도 ANC 성능이면 안됩니다. 지하철 탈 때 확실히 조용해지고, 통화 품질도 좋아요. 배터리도 오래가고 케이스도 해쌔서 매일 사용 중입니다.',
    createdAt: '2025.05.25',
    platform: '쿠팡',
    isVerifiedPurchase: true,
    rtiScore: 95,
    rtiColor: '#22C55E',
    rtiLabel: '신뢰도 높음',
    imageUrls: [
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&w=200&q=60',
    ],
    hashtags: ['ANC', '통화품질', '배터리'],
    rtiDetail: ReviewRtiDetail(
      summaryDescription: '구매 인증과 구체적인 사용 상황이 명확히 확인되어 신뢰도 매우 높은 리뷰로 분석되었어요.',
      summaryTags: [
        RtiSummaryTag(label: '구매인증 확인', type: RtiTagType.positive),
        RtiSummaryTag(label: '실사용 맥락 풍부', type: RtiTagType.positive),
        RtiSummaryTag(label: '반복 표현 낮음', type: RtiTagType.info),
      ],
      signals: [
        RtiSignal(label: '텍스트 신호', score: 92, iconType: 'text', color: '#3B82F6'),
        RtiSignal(label: '행동 신호', score: 95, iconType: 'behavior', color: '#22C55E'),
        RtiSignal(label: '패턴 자연스러움', score: 90, iconType: 'pattern', color: '#8B5CF6'),
        RtiSignal(label: '구매 인증', score: 100, iconType: 'purchase', color: '#22C55E'),
      ],
      judgmentBases: [
        RtiJudgmentBasis(
          label: '반복 표현 빈도 낮음',
          description: '동일 문구/단어 반복 사용이 적어 자연스러운 표현으로 판단됩니다.',
          percentage: 90,
          iconType: 'repeat',
          color: '#0891B2',
        ),
        RtiJudgmentBasis(
          label: '구체적 사용 맥락 포함',
          description: '사용 환경, 시간, 상황 등 구체적 맥락이 확인됩니다.',
          percentage: 88,
          iconType: 'context',
          color: '#22C55E',
        ),
        RtiJudgmentBasis(
          label: '구매 이력 패턴 자연스러움',
          description: '최근 구매 패턴과 리뷰 작성 간격이 자연스럽습니다.',
          percentage: 85,
          iconType: 'history',
          color: '#3B82F6',
        ),
        RtiJudgmentBasis(
          label: '유사 리뷰군과 거리 있음',
          description: '유사도 분석 결과 일반 리뷰와 비교해 자별화된 내용입니다.',
          percentage: 82,
          iconType: 'similarity',
          color: '#F97316',
        ),
      ],
      sentenceHighlights: [
        RtiSentenceHighlight(
          sentence: '이 가격에 이 정도 ANC 성능이면 안됩니다.',
          tag: '사용 맥락',
          color: '#FBBF24',
        ),
        RtiSentenceHighlight(
          sentence: '지하철 탈 때 확실히 조용해지고, 통화 품질도 좋아요.',
          tag: '구매 상황',
          color: '#0891B2',
        ),
        RtiSentenceHighlight(
          sentence: '배터리도 오래가고 케이스도 해쌔서 매일 사용 중입니다.',
          tag: '제품 특성',
          color: '#374151',
        ),
      ],
    ),
  ),
  ProductReview(
    id: 2,
    authorName: 'soyoung_music',
    authorAvatarUrl: null,
    rating: 4.0,
    content:
        '노이즈 캔슬링 성능이 정말 강력해요. 지하철 탈 때 주변 소음이 거의 안 들려서 집중하기 좋아요. 착용감도 가볍고 귀에 잘 맞아서 장시간 사용해도 불편함이 없어요. 배터리도 오래가고 케이스 디자인도 고급스러워 만족합니다.',
    createdAt: '2025.05.22',
    platform: '네이버쇼핑',
    isVerifiedPurchase: true,
    rtiScore: 86,
    rtiColor: '#22C55E',
    rtiLabel: '신뢰도 높음',
    imageUrls: [
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=200&q=60',
      'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=200&q=60',
    ],
    hashtags: ['ANC', '착용감', '배터리'],
    rtiDetail: ReviewRtiDetail(
      summaryDescription: '구매 인증 패턴과 구체적인 사용 맥락이 확인되어 신뢰도 높은 리뷰로 분석되었어요.',
      summaryTags: [
        RtiSummaryTag(label: '구매인증 확인', type: RtiTagType.positive),
        RtiSummaryTag(label: '실사용 맥락 풍부', type: RtiTagType.positive),
        RtiSummaryTag(label: '반복 표현 낮음', type: RtiTagType.info),
      ],
      signals: [
        RtiSignal(label: '텍스트 신호', score: 88, iconType: 'text', color: '#3B82F6'),
        RtiSignal(label: '행동 신호', score: 82, iconType: 'behavior', color: '#22C55E'),
        RtiSignal(label: '패턴 자연스러움', score: 84, iconType: 'pattern', color: '#8B5CF6'),
        RtiSignal(label: '구매 인증', score: 100, iconType: 'purchase', color: '#22C55E'),
      ],
      judgmentBases: [
        RtiJudgmentBasis(
          label: '반복 표현 빈도 낮음',
          description: '동일 문구/단어 반복 사용이 적어 자연스러운 표현으로 판단됩니다.',
          percentage: 85,
          iconType: 'repeat',
          color: '#0891B2',
        ),
        RtiJudgmentBasis(
          label: '구체적 사용 맥락 포함',
          description: '사용 환경, 시간, 상황 등 구체적 맥락이 확인됩니다.',
          percentage: 82,
          iconType: 'context',
          color: '#22C55E',
        ),
        RtiJudgmentBasis(
          label: '구매 이력 패턴 자연스러움',
          description: '최근 구매 패턴과 리뷰 작성 간격이 자연스럽습니다.',
          percentage: 78,
          iconType: 'history',
          color: '#3B82F6',
        ),
        RtiJudgmentBasis(
          label: '유사 리뷰군과 거리 있음',
          description: '유사도 분석 결과 일반 리뷰와 비교해 자별화된 내용입니다.',
          percentage: 76,
          iconType: 'similarity',
          color: '#F97316',
        ),
      ],
      sentenceHighlights: [
        RtiSentenceHighlight(
          sentence: '노이즈 캔슬링 성능이 정말 강력해요.',
          tag: '사용 맥락',
          color: '#FBBF24',
        ),
        RtiSentenceHighlight(
          sentence: '지하철 탈 때 주변 소음이 거의 안 들려서 집중하기 좋아요.',
          tag: '구매 상황',
          color: '#0891B2',
        ),
        RtiSentenceHighlight(
          sentence: '배터리도 오래가고 케이스 디자인도 고급스러워 만족합니다.',
          tag: '제품 특성',
          color: '#374151',
        ),
      ],
    ),
  ),
  ProductReview(
    id: 3,
    authorName: 'review_7781',
    authorAvatarUrl: null,
    rating: 4.0,
    content:
        '정말 좋아요. 음질 기대 이상이고요, 노이즈도 확실합니다. 온종일 빼도 안 빠지고 안정적이에요.',
    createdAt: '2025.05.20',
    platform: '11번가',
    isVerifiedPurchase: false,
    rtiScore: 90,
    rtiColor: '#22C55E',
    rtiLabel: '신뢰도 높음',
    imageUrls: [],
    rtiDetail: ReviewRtiDetail(
      summaryDescription: '간결하지만 핵심 사용 경험이 담긴 신뢰도 높은 리뷰로 분석되었어요.',
      summaryTags: [
        RtiSummaryTag(label: '실사용 맥락 포함', type: RtiTagType.positive),
        RtiSummaryTag(label: '반복 표현 낮음', type: RtiTagType.info),
      ],
      signals: [
        RtiSignal(label: '텍스트 신호', score: 85, iconType: 'text', color: '#3B82F6'),
        RtiSignal(label: '행동 신호', score: 88, iconType: 'behavior', color: '#22C55E'),
        RtiSignal(label: '패턴 자연스러움', score: 91, iconType: 'pattern', color: '#8B5CF6'),
        RtiSignal(label: '구매 인증', score: 80, iconType: 'purchase', color: '#22C55E'),
      ],
      judgmentBases: [
        RtiJudgmentBasis(
          label: '반복 표현 빈도 낮음',
          description: '동일 문구/단어 반복 사용이 적어 자연스러운 표현으로 판단됩니다.',
          percentage: 88,
          iconType: 'repeat',
          color: '#0891B2',
        ),
        RtiJudgmentBasis(
          label: '구체적 사용 맥락 포함',
          description: '사용 환경, 시간, 상황 등 구체적 맥락이 확인됩니다.',
          percentage: 80,
          iconType: 'context',
          color: '#22C55E',
        ),
        RtiJudgmentBasis(
          label: '구매 이력 패턴 자연스러움',
          description: '최근 구매 패턴과 리뷰 작성 간격이 자연스럽습니다.',
          percentage: 86,
          iconType: 'history',
          color: '#3B82F6',
        ),
        RtiJudgmentBasis(
          label: '유사 리뷰군과 거리 있음',
          description: '유사도 분석 결과 일반 리뷰와 비교해 자별화된 내용입니다.',
          percentage: 79,
          iconType: 'similarity',
          color: '#F97316',
        ),
      ],
      sentenceHighlights: [
        RtiSentenceHighlight(
          sentence: '음질 기대 이상이고요, 노이즈도 확실합니다.',
          tag: '사용 맥락',
          color: '#FBBF24',
        ),
        RtiSentenceHighlight(
          sentence: '온종일 빼도 안 빠지고 안정적이에요.',
          tag: '제품 특성',
          color: '#0891B2',
        ),
      ],
    ),
  ),
];

const _mockInsight = ReviewInsight(
  keywords: [
    ReviewKeyword(label: '노이즈캔슬링', count: 12641),
    ReviewKeyword(label: '음질', count: 9872),
    ReviewKeyword(label: '착용감', count: 8396),
    ReviewKeyword(label: '배터리', count: 7155),
    ReviewKeyword(label: '통화품질', count: 5986),
    ReviewKeyword(label: '가성비', count: 4672),
  ],
  satisfactionPoints: [
    '강력한 ANC 성능',
    '편안한 착용감',
    '선명한 통화 품질',
    '긴 배터리 지속시간',
  ],
  dissatisfactionPoints: [
    '터치 조작 인감도',
    '제품 크기(휴대성)',
    '앱 기능 단순함',
  ],
);

const _mockSimilarProducts = [
  SimilarProduct(
    id: 10,
    name: 'Air5 Pro ANC 블루투스 이어폰',
    brand: 'SoundPEATS',
    imageUrl:
        'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=400&q=70',
    price: 89000,
    avgRating: 4.6,
    reviewCount: 13428,
    avgRti: 94,
    rtiColor: '#22C55E',
  ),
  SimilarProduct(
    id: 11,
    name: 'AirPods Pro 2세대 (USB-C)',
    brand: 'Apple',
    imageUrl:
        'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&w=400&q=70',
    price: 279000,
    avgRating: 4.7,
    reviewCount: 7063,
    avgRti: 95,
    rtiColor: '#22C55E',
  ),
  SimilarProduct(
    id: 12,
    name: 'W1-1000XM2 넥밴드 블루투스 이어폰',
    brand: 'AKG',
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=400&q=70',
    price: 149000,
    avgRating: 4.5,
    reviewCount: 872,
    avgRti: 93,
    rtiColor: '#22C55E',
  ),
  SimilarProduct(
    id: 13,
    name: 'QuietComfort Earbuds II',
    brand: 'Bose',
    imageUrl:
        'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=400&q=70',
    price: 239000,
    avgRating: 4.6,
    reviewCount: 10068,
    avgRti: 92,
    rtiColor: '#22C55E',
  ),
  SimilarProduct(
    id: 14,
    name: 'Live Flex 3',
    brand: 'JBL',
    imageUrl:
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=400&q=70',
    price: 129000,
    avgRating: 4.5,
    reviewCount: 745,
    avgRti: 91,
    rtiColor: '#22C55E',
  ),
];
