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
  final keywordTokens = keyword
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList(growable: false);
  final products = keyword.isEmpty
      ? mockSearchProducts
      : mockSearchProducts
            .where((product) {
              final searchableText = [
                product.name,
                product.category,
                product.categoryDisplayName,
                product.platform,
              ].whereType<String>().join(' ').toLowerCase();

              return keywordTokens.any(searchableText.contains);
            })
            .toList(growable: false);

  return SearchResultsState(
    query: query.trim(),
    products: products,
    totalCount: query.trim().isEmpty ? products.length : 248,
    quickFilters: [
      SearchFilterChipData(label: '전체', count: 248, selected: true),
      const SearchFilterChipData(label: 'RTI 80+', count: 132),
      const SearchFilterChipData(label: '무선', count: 224),
      const SearchFilterChipData(label: '노이즈캔슬링', count: 164),
      const SearchFilterChipData(label: '커널형', count: 118),
      const SearchFilterChipData(label: '오픈형', count: 72),
      const SearchFilterChipData(label: '스포츠/방수', count: 45),
      const SearchFilterChipData(label: '게이밍', count: 31),
      const SearchFilterChipData(label: '통화 품질 우수', count: 54),
    ],
    categoryFilters: const [
      SearchFilterChipData(label: '이어폰', count: 142, selected: true),
      SearchFilterChipData(label: '헤드폰', count: 61),
      SearchFilterChipData(label: '스피커', count: 24),
      SearchFilterChipData(label: '액세서리', count: 21),
    ],
    priceRanges: const [
      SearchFilterChipData(label: '1만원 이하', count: 18),
      SearchFilterChipData(label: '10~30만원', count: 73),
      SearchFilterChipData(label: '30만원 이상', count: 92),
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

const mockProductTraitChips = [
  ['가성비', '강한 ANC'],
  ['편안한 착용감', '통화 선명'],
  ['신상품', '초경량'],
  ['프리미엄 음질', '아이폰 추천'],
  ['통화 품질 우수', '저지연'],
  ['생활방수', '긴 배터리'],
];

String mockBrandFor(SearchResultProduct product) {
  final index = (product.id - 1).clamp(0, mockSearchBrands.length - 1);
  return mockSearchBrands[index];
}

String mockBadgeFor(SearchResultProduct product) {
  final index = (product.id - 1).clamp(0, mockProductBadges.length - 1);
  return mockProductBadges[index];
}

List<String> mockTraitChipsFor(SearchResultProduct product) {
  final index = (product.id - 1).clamp(0, mockProductTraitChips.length - 1);
  return mockProductTraitChips[index];
}
