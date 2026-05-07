import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/app/theme/app_theme.dart';

void main() {
  test('defines core color tokens for the app theme', () {
    expect(AppColors.primary, const Color(0xFF2563EB));
    expect(AppColors.background, const Color(0xFFF8FAFC));
    expect(AppColors.error, const Color(0xFFDC2626));
  });

  test('defines common spacing and radius scale', () {
    expect(AppSpacing.md, 16);
    expect(AppSpacing.xl, 32);
    expect(AppRadius.sm, 8);
  });

  test('maps text styles and component tokens into light theme', () {
    final theme = AppTheme.light;

    expect(
      theme.textTheme.displayLarge?.fontSize,
      AppTextStyles.displayLarge.fontSize,
    );
    expect(
      theme.textTheme.titleMedium?.fontWeight,
      AppTextStyles.titleMedium.fontWeight,
    );
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
  });
}
