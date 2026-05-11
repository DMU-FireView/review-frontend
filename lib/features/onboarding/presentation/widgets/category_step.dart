import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/features/onboarding/domain/entities/interest_category.dart';
import 'package:re_view_front/features/onboarding/presentation/widgets/category_card.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class CategoryStep extends StatelessWidget {
  const CategoryStep({
    required this.selectedCategories,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
    super.key,
  });

  final Set<InterestCategory> selectedCategories;
  final ValueChanged<InterestCategory> onToggle;
  final VoidCallback? onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _CategoryForm(
            selectedCategories: selectedCategories,
            onToggle: onToggle,
            onNext: onNext,
            onSkip: onSkip,
          ),
        ),
        if (!context.isMobile) ...[
          Container(width: 1, color: AppColors.border),
          const SizedBox(width: AppSpacing.xl),
          SizedBox(
            width: 320,
            child: _CategoryPreviewPanel(
              selectedCategories: selectedCategories,
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryForm extends StatelessWidget {
  const _CategoryForm({
    required this.selectedCategories,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
  });

  final Set<InterestCategory> selectedCategories;
  final ValueChanged<InterestCategory> onToggle;
  final VoidCallback? onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('관심 있는 카테고리를 선택해 주세요', style: AppTextStyles.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '선택한 카테고리를 바탕으로 맞춤 리뷰와 추천 상품을 보여드려요.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.1,
            children: InterestCategory.values
                .map(
                  (category) => CategoryCard(
                    category: category,
                    isSelected: selectedCategories.contains(category),
                    onTap: () => onToggle(category),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (selectedCategories.isNotEmpty) ...[
            Text(
              '선택한 카테고리 (${selectedCategories.length})',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: selectedCategories
                  .map(
                    (category) => Chip(
                      label: Text(
                        category.label,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      backgroundColor: AppColors.primaryLight,
                      side: const BorderSide(color: AppColors.primary),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      onDeleted: () => onToggle(category),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ] else
            const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              OutlinedButton(
                onPressed: onSkip,
                child: const Text('나중에 할게요'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.arrow_forward, size: 18),
                iconAlignment: IconAlignment.end,
                label: const Text('다음: 알림 설정'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPreviewPanel extends StatelessWidget {
  const _CategoryPreviewPanel({required this.selectedCategories});

  final Set<InterestCategory> selectedCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이런 상품과 리뷰를 보여드려요', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '선택한 카테고리와 관련된 추천 예시예요.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (selectedCategories.isEmpty)
          _EmptyPreview()
        else
          _SelectedPreview(categories: selectedCategories),
      ],
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 40,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '카테고리를 선택하면\n맞춤 추천이 시작돼요',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedPreview extends StatelessWidget {
  const _SelectedPreview({required this.categories});

  final Set<InterestCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '선택된 카테고리',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: categories
                .map(
                  (c) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.small,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, size: 14, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          c.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  '실제 추천 결과는 회원님의 활동에 따라 달라질 수 있어요.',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
