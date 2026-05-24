import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

String formatSearchPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return '$buffer원';
}

String formatSearchCount(int count) {
  final digits = count.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

Color colorFromHex(String hex) {
  final normalized = hex.replaceFirst('#', '');
  final value = int.tryParse('FF$normalized', radix: 16);
  if (value == null) {
    return AppColors.primary;
  }

  return Color(value);
}
