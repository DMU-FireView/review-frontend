import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    this.focusNode,
    this.initialValue,
    this.onSubmitted,
    this.onSearchPressed,
    super.key,
  });

  final FocusNode? focusNode;
  final String? initialValue;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSearchPressed;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextValue = widget.initialValue ?? '';
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != nextValue) {
      _controller.text = nextValue;
      _controller.selection = TextSelection.collapsed(offset: nextValue.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered || _isFocused
        ? const Color(0xFFF8FAFF)
        : AppColors.surface;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
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
              onFocusChange: _setFocused,
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: '찾고 있는 상품을 리뷰 기반으로 검색해보세요',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: IconButton(
                    tooltip: '검색',
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed: widget.onSearchPressed == null
                        ? null
                        : () => widget.onSearchPressed!(_controller.text),
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

  void _setHovered(bool value) {
    if (_isHovered == value) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isHovered != value) {
        setState(() => _isHovered = value);
      }
    });
  }

  void _setFocused(bool value) {
    if (_isFocused == value) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isFocused != value) {
        setState(() => _isFocused = value);
      }
    });
  }
}
