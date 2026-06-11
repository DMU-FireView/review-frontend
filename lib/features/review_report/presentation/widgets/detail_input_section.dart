import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';

class DetailInputSection extends StatefulWidget {
  const DetailInputSection({
    super.key,
    required this.controller,
    required this.reportType,
    required this.disclosure,
    required this.onReportTypeChanged,
    required this.onDisclosureChanged,
    this.onAttach,
  });

  final TextEditingController controller;
  final String? reportType;
  final String? disclosure;
  final ValueChanged<String?> onReportTypeChanged;
  final ValueChanged<String?> onDisclosureChanged;
  final VoidCallback? onAttach;

  @override
  State<DetailInputSection> createState() => _DetailInputSectionState();
}

class _DetailInputSectionState extends State<DetailInputSection> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _charCount = widget.controller.text.trim().length;
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() => _charCount = widget.controller.text.trim().length);
  }

  @override
  Widget build(BuildContext context) {
    final isEnough = _charCount >= 20;

    return SectionCard(
      title: '상세 근거 입력',
      description: '신고 판단에 도움이 되는 내용을 남겨주세요.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledDropdown(
                  label: '신고 유형',
                  value: widget.reportType,
                  items: const ['반복 문구', '계정 생성 직후', '유사 리뷰 군집', '기타'],
                  onChanged: widget.onReportTypeChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _LabeledDropdown(
                  label: '처리 결과 공개 범위',
                  value: widget.disclosure,
                  items: const ['비공개', '나에게만 공개', '운영팀 공유'],
                  onChanged: widget.onDisclosureChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '상세 설명',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: widget.controller,
            maxLines: 5,
            validator: (v) {
              if (v == null || v.trim().length < 20) {
                return '최소 20자 이상 입력해주세요.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: '구체적인 문제 내용과 맥락을 입력해주세요.',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  isEnough
                      ? '최소 20자 이상 입력하면 운영팀 검토에 더 도움이 돼요.'
                      : '최소 20자 이상 입력해주세요.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isEnough
                        ? AppColors.textTertiary
                        : AppColors.error,
                  ),
                ),
              ),
              Text(
                '$_charCount자',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isEnough
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '첨부 자료 (선택)',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _AttachmentBox(onAttach: widget.onAttach),
        ],
      ),
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          hint: const Text(
            '선택해주세요',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textTertiary,
            size: 20,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentBox extends StatelessWidget {
  const _AttachmentBox({this.onAttach});

  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAttach,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.upload_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '스크린샷이나 추가 근거를 첨부해주세요',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'PNG, JPG, PDF · 최대 10MB · 최대 4개',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: onAttach,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderStrong),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                '파일 선택',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
