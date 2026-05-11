import 'package:flutter/material.dart';

enum InterestCategory {
  digital('디지털/가전', Icons.headphones_outlined),
  fashion('패션', Icons.checkroom_outlined),
  beauty('뷰티', Icons.spa_outlined),
  food('식품', Icons.shopping_basket_outlined),
  living('생활/건강', Icons.monitor_heart_outlined),
  pet('반려동물', Icons.pets),
  travel('여행/레저', Icons.luggage_outlined),
  kids('키즈', Icons.child_care_outlined);

  const InterestCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}
