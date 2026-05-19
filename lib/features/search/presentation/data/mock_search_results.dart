import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

const mockSearchProducts = [
  SearchResultProduct(
    id: 'mock-stand-mixer-01',
    name: '브리즈핸드 무선 핸디 선풍기 4세대',
    storeName: 'Breeze Lab',
    category: '가전',
    price: 34900,
    originalPrice: 42900,
    rating: 4.8,
    reviewCount: 1832,
    rtiScore: 94,
    imageUrl:
        'https://images.unsplash.com/photo-1585338107529-13afc5f02586?auto=format&fit=crop&w=700&q=80',
    summary: '소음과 배터리 지속시간에 대한 실제 사용 리뷰가 안정적으로 유지되고 있어요.',
    badge: 'RTI 추천',
  ),
  SearchResultProduct(
    id: 'mock-cleaner-02',
    name: '라이트클린 무선 청소기 미니',
    storeName: 'Light Clean',
    category: '생활',
    price: 89900,
    originalPrice: 119000,
    rating: 4.6,
    reviewCount: 926,
    rtiScore: 88,
    imageUrl:
        'https://images.unsplash.com/photo-1558317374-067fb5f30001?auto=format&fit=crop&w=700&q=80',
    summary: '흡입력 만족 리뷰가 많고, 반복 문구 비율이 낮은 편입니다.',
    badge: '리뷰 안정',
  ),
  SearchResultProduct(
    id: 'mock-cream-03',
    name: '세라 수분 장벽 크림 80ml',
    storeName: 'Derma Note',
    category: '뷰티',
    price: 21800,
    originalPrice: 27000,
    rating: 4.7,
    reviewCount: 3140,
    rtiScore: 91,
    imageUrl:
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=700&q=80',
    summary: '민감성 피부 리뷰의 표현 편차가 자연스럽고 재구매 언급이 많습니다.',
    badge: '재구매 높음',
  ),
  SearchResultProduct(
    id: 'mock-coffee-04',
    name: '데일리 콜드브루 원액 12개입',
    storeName: 'Morning Bean',
    category: '푸드',
    price: 16900,
    originalPrice: 19900,
    rating: 4.5,
    reviewCount: 711,
    rtiScore: 83,
    imageUrl:
        'https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=700&q=80',
    summary: '맛과 배송 상태 리뷰가 고르게 분포하지만 일부 프로모션성 문구가 감지됩니다.',
    badge: '가격 좋음',
  ),
  SearchResultProduct(
    id: 'mock-chair-05',
    name: '모듈핏 메쉬 사무용 의자',
    storeName: 'Work Studio',
    category: '인테리어',
    price: 149000,
    originalPrice: 179000,
    rating: 4.4,
    reviewCount: 504,
    rtiScore: 79,
    imageUrl:
        'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?auto=format&fit=crop&w=700&q=80',
    summary: '조립 난이도와 착좌감 리뷰가 충분하지만 체형별 평가 편차가 있습니다.',
    badge: '비교 필요',
  ),
];

SearchResultsState mockSearchResultsFor(String query) {
  final keyword = query.trim().toLowerCase();
  final products = keyword.isEmpty
      ? mockSearchProducts
      : mockSearchProducts
            .where((product) {
              return product.name.toLowerCase().contains(keyword) ||
                  product.storeName.toLowerCase().contains(keyword) ||
                  product.category.toLowerCase().contains(keyword);
            })
            .toList(growable: false);

  return SearchResultsState(
    query: query.trim(),
    products: products,
    filters: [
      SearchFilterChipData(label: '전체', count: products.length, selected: true),
      SearchFilterChipData(
        label: 'RTI 90+',
        count: products.where((product) => product.rtiScore >= 90).length,
      ),
      SearchFilterChipData(
        label: '리뷰 1,000+',
        count: products.where((product) => product.reviewCount >= 1000).length,
      ),
      SearchFilterChipData(
        label: '할인중',
        count: products
            .where((product) => product.originalPrice != null)
            .length,
      ),
    ],
  );
}
