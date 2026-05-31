import 'package:flutter/material.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';

const homeNavItems = [
  '홈',
  '브랜드데이',
  '베스트',
  '신상품',
  '타임딜',
  '리뷰 LIVE',
  '리뷰랭킹',
  '기획전',
  '선물하기',
  '반려동물',
  '여행/레저',
];

const banners = [
  HomeBannerData(
    title: '리뷰가 증명하는 여름 준비',
    emphasis: '쿨썸머 인기템 모음',
    description: '실사용 리뷰로 고른 믿을 수 있는 선택',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_1.png',
    color: Color(0xFFEAF4FF),
    accentColor: Color(0xFF2563EB),
    icon: Icons.air,
  ),
  HomeBannerData(
    title: '신선함이 다르다',
    emphasis: '산지 직송 특가',
    description: '리뷰 흐름이 안정적인 신선 식품을 먼저 확인하세요',
    ctaLabel: '자세히 보기',
    badgeLabel: 'RTI 안정',
    assetPath: 'assets/images/home/banners/banner_2.png',
    color: Color(0xFFEAF6E6),
    accentColor: Color(0xFF2E7D32),
    icon: Icons.eco_outlined,
  ),
  HomeBannerData(
    title: '리뷰 신뢰도 높은 뷰티템',
    emphasis: '광고성 리뷰 걱정 없이',
    description: '반복 패턴과 광고 신호를 낮춘 뷰티 상품 흐름',
    ctaLabel: '둘러보기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_3.png',
    color: Color(0xFFFFF1F7),
    accentColor: Color(0xFFE65100),
    icon: Icons.spa_outlined,
  ),
  HomeBannerData(
    title: '반려생활 필수템 모음',
    emphasis: '리뷰로 고른 생활템',
    description: '검증된 리뷰 흐름을 기준으로 탐색하세요',
    ctaLabel: '더 알아보기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_4.png',
    color: Color(0xFFF8FAFC),
    accentColor: Color(0xFF0F172A),
    icon: Icons.pets_outlined,
  ),
];

const quickCategories = [
  QuickCategoryData(
    label: '오늘출발',
    iconAssetPath: 'assets/images/home/icons/icon-quick-delivery.png',
  ),
  QuickCategoryData(
    label: '브랜드데이',
    iconAssetPath: 'assets/images/home/icons/icon-brand-day.png',
  ),
  QuickCategoryData(
    label: '타임딜',
    iconAssetPath: 'assets/images/home/icons/icon-time-deal.png',
  ),
  QuickCategoryData(
    label: '리뷰랭킹',
    iconAssetPath: 'assets/images/home/icons/icon-review-ranking.png',
  ),
  QuickCategoryData(
    label: '선물하기',
    iconAssetPath: 'assets/images/home/icons/icon-gift.png',
  ),
  QuickCategoryData(
    label: '뷰티',
    iconAssetPath: 'assets/images/home/icons/icon-beauty.png',
  ),
  QuickCategoryData(
    label: '가전',
    iconAssetPath: 'assets/images/home/icons/icon-appliance.png',
  ),
  QuickCategoryData(
    label: '인테리어',
    iconAssetPath: 'assets/images/home/icons/icon-interior.png',
  ),
  QuickCategoryData(
    label: '푸드',
    iconAssetPath: 'assets/images/home/icons/icon-food.png',
  ),
  QuickCategoryData(
    label: '스포츠',
    iconAssetPath: 'assets/images/home/icons/icon-sports.png',
  ),
  QuickCategoryData(
    label: '전체보기',
    iconAssetPath: 'assets/images/home/icons/icon-all-categories.png',
  ),
];

const trendingKeywords = <String>[];

const recommendedProducts = <HomeProductData>[];

final popularCategories = [
  for (final category in productCategoryTree)
    PopularCategoryData(
      label: category.label,
      icon: _popularCategoryIcons[category.id] ?? Icons.category_outlined,
    ),
];

const _popularCategoryIcons = {
  'digital-appliance': Icons.devices_other_outlined,
  'fashion-clothing': Icons.checkroom_outlined,
  'fashion-accessory': Icons.shopping_bag_outlined,
  'beauty': Icons.spa_outlined,
  'food': Icons.restaurant_outlined,
  'living-kitchen': Icons.kitchen_outlined,
  'furniture-interior': Icons.chair_outlined,
  'sports-leisure': Icons.sports_soccer_outlined,
  'car-tools': Icons.directions_car_outlined,
  'baby-kids': Icons.child_care_outlined,
  'pet': Icons.pets_outlined,
  'book-stationery-hobby': Icons.menu_book_outlined,
  'travel-service': Icons.luggage_outlined,
  'luxury-brand': Icons.diamond_outlined,
};

const benefitItems = [
  BenefitData(title: '10%', description: '웰컴 쿠폰'),
  BenefitData(title: '무료', description: '배송 쿠폰'),
  BenefitData(title: '3,000P', description: '적립금'),
];

class HomeBannerData {
  const HomeBannerData({
    required this.title,
    required this.emphasis,
    required this.description,
    required this.ctaLabel,
    required this.badgeLabel,
    required this.assetPath,
    required this.color,
    required this.accentColor,
    required this.icon,
  });

  final String title;
  final String emphasis;
  final String description;
  final String ctaLabel;
  final String badgeLabel;
  final String assetPath;
  final Color color;
  final Color accentColor;
  final IconData icon;
}

class QuickCategoryData {
  const QuickCategoryData({required this.label, required this.iconAssetPath});

  final String label;
  final String iconAssetPath;
}

class HomeProductData {
  const HomeProductData({
    required this.productId,
    required this.name,
    required this.storeName,
    required this.priceLabel,
    required this.ratingLabel,
    required this.reviewCountLabel,
    required this.rtiLabel,
    required this.imageUrl,
    required this.label,
  });

  final String productId;
  final String name;
  final String storeName;
  final String priceLabel;
  final String ratingLabel;
  final String reviewCountLabel;
  final String rtiLabel;
  final String imageUrl;
  final String label;
}

class PopularCategoryData {
  const PopularCategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class BenefitData {
  const BenefitData({required this.title, required this.description});

  final String title;
  final String description;
}
