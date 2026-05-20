import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

const mockSearchProducts = [
  SearchResultProduct(
    id: 1,
    name: 'AeroFit ANC 무선 블루투스 이어폰',
    imageUrl:
        'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=700&q=80',
    price: 89000,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 91,
    rtiGrade: 'SAFE',
    rtiColor: '#22C55E',
    reviewCount: 1284,
    avgRating: 4.8,
  ),
  SearchResultProduct(
    id: 2,
    name: '이어온 QuietBuds Lite ANC 커널형 무선',
    imageUrl:
        'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=700&q=80',
    price: 62500,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 63,
    rtiGrade: 'SUSPICIOUS',
    rtiColor: '#F97316',
    reviewCount: 892,
    avgRating: 4.5,
  ),
  SearchResultProduct(
    id: 3,
    name: 'XY Pro 초경량 ANC 블루투스 이어폰 2026 신형',
    imageUrl:
        'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&w=700&q=80',
    price: 39900,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 38,
    rtiGrade: 'DANGER',
    rtiColor: '#EF4444',
    reviewCount: 2104,
    avgRating: 4.7,
  ),
  SearchResultProduct(
    id: 4,
    name: '아이오 플러스 StudioTone ANC 프리미엄 무선',
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=700&q=80',
    price: 149000,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 82,
    rtiGrade: 'SAFE',
    rtiColor: '#22C55E',
    reviewCount: 456,
    avgRating: 4.9,
  ),
  SearchResultProduct(
    id: 5,
    name: '더블팟Pods ANC 통화 노이즈 저감 이어셋',
    imageUrl:
        'https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=700&q=80',
    price: 74000,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 58,
    rtiGrade: 'SUSPICIOUS',
    rtiColor: '#F97316',
    reviewCount: 318,
    avgRating: 4.4,
  ),
  SearchResultProduct(
    id: 6,
    name: 'AirWave ANC 생활방수 블루투스 이어폰',
    imageUrl:
        'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=700&q=80',
    price: 55900,
    category: 'ELECTRONICS',
    categoryDisplayName: '이어폰',
    platform: null,
    avgRti: 76,
    rtiGrade: 'SAFE',
    rtiColor: '#22C55E',
    reviewCount: 742,
    avgRating: 4.6,
  ),
];

SearchResultsState mockSearchResultsFor(String query) {
  final keyword = query.trim().toLowerCase();
  final products = keyword.isEmpty
      ? mockSearchProducts
      : mockSearchProducts
            .where((product) {
              return product.name.toLowerCase().contains(keyword) ||
                  product.category.toLowerCase().contains(keyword) ||
                  product.categoryDisplayName.toLowerCase().contains(keyword);
            })
            .toList(growable: false);

  return SearchResultsState(
    query: query.trim(),
    products: products,
    totalCount: query.trim().isEmpty ? products.length : 248,
    quickFilters: [
      SearchFilterChipData(label: '전체', count: 248, selected: true),
      const SearchFilterChipData(label: 'RTI 80+', count: 132),
      const SearchFilterChipData(label: '아이폰 추천', count: 86),
      const SearchFilterChipData(label: '통화 품질 우수', count: 54),
      const SearchFilterChipData(label: '장시간 배터리', count: 47),
      const SearchFilterChipData(label: '가성비', count: 39),
      const SearchFilterChipData(label: '출시 6개월 이내', count: 22),
      const SearchFilterChipData(label: '무선충전 지원', count: 18),
    ],
    categoryFilters: const [
      SearchFilterChipData(label: '이어폰', count: 142, selected: true),
      SearchFilterChipData(label: '헤드폰', count: 61),
      SearchFilterChipData(label: '스피커', count: 24),
      SearchFilterChipData(label: '액세서리', count: 21),
    ],
    priceRanges: const [
      SearchFilterChipData(label: '3만원 이하', count: 18),
      SearchFilterChipData(label: '3~7만원', count: 73),
      SearchFilterChipData(label: '7~15만원', count: 92),
      SearchFilterChipData(label: '15만원 이상', count: 65, selected: true),
    ],
  );
}

const mockSearchBrands = [
  'SoundRoom',
  'Modern Audio',
  'Daily Gadget',
  'Audio Lab',
  'Tech Corner',
  'Base Market',
];

const mockProductBadges = ['무료배송', '오늘출발', '특가', '무료배송', '오늘출발', '무료배송'];

String mockBrandFor(SearchResultProduct product) {
  final index = (product.id - 1).clamp(0, mockSearchBrands.length - 1);
  return mockSearchBrands[index];
}

String mockBadgeFor(SearchResultProduct product) {
  final index = (product.id - 1).clamp(0, mockProductBadges.length - 1);
  return mockProductBadges[index];
}
