import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({this.focusNode, super.key});

  final FocusNode? focusNode;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered || _isFocused
        ? const Color(0xFFF8FAFF)
        : AppColors.surface;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused || _isHovered
                ? AppColors.primary
                : AppColors.borderStrong,
            width: _isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            if (_isFocused)
              const BoxShadow(
                color: Color(0x1A2563EB),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ColoredBox(
            color: backgroundColor,
            child: Focus(
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: TextField(
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: '찾고 있는 상품을 리뷰 기반으로 검색해보세요',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: backgroundColor,
                  hoverColor: backgroundColor,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 13,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
