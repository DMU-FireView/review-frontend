import 'package:flutter/material.dart';

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
  QuickCategoryData(label: '오늘출발', icon: Icons.local_shipping_outlined),
  QuickCategoryData(label: '브랜드데이', icon: Icons.workspace_premium_outlined),
  QuickCategoryData(label: '타임딜', icon: Icons.percent_outlined),
  QuickCategoryData(label: '리뷰랭킹', icon: Icons.emoji_events_outlined),
  QuickCategoryData(label: '선물하기', icon: Icons.card_giftcard_outlined),
  QuickCategoryData(label: '뷰티', icon: Icons.spa_outlined),
  QuickCategoryData(label: '가전', icon: Icons.devices_other_outlined),
  QuickCategoryData(label: '인테리어', icon: Icons.chair_outlined),
  QuickCategoryData(label: '푸드', icon: Icons.apple_outlined),
  QuickCategoryData(label: '스포츠', icon: Icons.sports_tennis_outlined),
  QuickCategoryData(label: '전체보기', icon: Icons.grid_view_outlined),
];

const recommendedProducts = <HomeProductData>[];

const popularCategories = [
  PopularCategoryData(label: '여성패션', icon: Icons.checkroom_outlined),
  PopularCategoryData(label: '남성패션', icon: Icons.man_2_outlined),
  PopularCategoryData(label: '신발/잡화', icon: Icons.shopping_bag_outlined),
  PopularCategoryData(label: '뷰티', icon: Icons.spa_outlined),
  PopularCategoryData(label: '가전/디지털', icon: Icons.devices_other_outlined),
  PopularCategoryData(label: '가구/인테리어', icon: Icons.chair_outlined),
  PopularCategoryData(label: '식품/건강', icon: Icons.restaurant_outlined),
  PopularCategoryData(label: '스포츠/레저', icon: Icons.sports_tennis_outlined),
];

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
  const QuickCategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class HomeProductData {
  const HomeProductData({
    required this.name,
    required this.storeName,
    required this.priceLabel,
    required this.ratingLabel,
    required this.reviewCountLabel,
    required this.rtiLabel,
    required this.imageUrl,
    required this.label,
  });

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
