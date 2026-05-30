import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/storage/web_storage.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';

const _recentSearchStorageKey = 'home_recent_search_queries';

class SearchBar extends StatefulWidget {
  const SearchBar({
    this.focusNode,
    this.initialValue,
    this.suggestionKeywords = const [],
    this.recommendedProducts = const [],
    this.onSubmitted,
    this.onSearchPressed,
    super.key,
  });

  final FocusNode? focusNode;
  final String? initialValue;
  final List<String> suggestionKeywords;
  final List<HomeProductData> recommendedProducts;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSearchPressed;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _fallbackFocusNode;
  final _searchBarKey = GlobalKey();
  OverlayEntry? _suggestionOverlayEntry;
  bool _isFocused = false;
  bool _isHovered = false;
  List<String> _recentQueries = const [];
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _containerKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _fallbackFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _fallbackFocusNode = FocusNode();
    _effectiveFocusNode.addListener(_syncFocusState);
    _isFocused = _effectiveFocusNode.hasFocus;
    _recentQueries = _readRecentQueries();
  }

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _fallbackFocusNode).removeListener(
        _syncFocusState,
      );
      _effectiveFocusNode.addListener(_syncFocusState);
      _isFocused = _effectiveFocusNode.hasFocus;
    }

    final nextValue = widget.initialValue ?? '';
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != nextValue) {
      _controller.text = nextValue;
      _controller.selection = TextSelection.collapsed(offset: nextValue.length);
    }
  }

  @override
  void dispose() {
    _hideSuggestionsOverlay();
    _removeOverlay();
    _effectiveFocusNode.removeListener(_syncFocusState);
    _fallbackFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _removeOverlay();
    if (!mounted) return;

    final renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    final width = renderBox?.size.width ?? 500.0;
    final products = widget.recommendedProducts.take(2).toList();

    _overlayEntry = OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 58),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: _SearchSuggestionPanel(
              keywords: widget.suggestionKeywords,
              recentQueries: _recentQueries,
              products: products,
              onKeywordPressed: _submitQuery,
              onRecentQueryPressed: _submitQuery,
              onRecentQueryDeleted: _removeRecentQuery,
              onRecentQueriesCleared: _clearRecentQueries,
              onProductPressed: (product) => _submitQuery(product.name),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered || _isFocused
        ? const Color(0xFFF8FAFF)
        : AppColors.surface;

    return MouseRegion(
      key: _searchBarKey,
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
            child: TextField(
              controller: _controller,
              focusNode: _effectiveFocusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitQuery,
              decoration: InputDecoration(
                hintText: '찾고 있는 상품을 리뷰 기반으로 검색해보세요',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
                suffixIcon: IconButton(
                  tooltip: '검색',
                  icon: const Icon(Icons.search, color: AppColors.primary),
                  onPressed:
                      widget.onSubmitted == null &&
                          widget.onSearchPressed == null
                      ? null
                      : () => _submitQuery(_controller.text, byIcon: true),
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
    );
  }

  void _submitQuery(String value, {bool byIcon = false}) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }

    if (_controller.text != query) {
      _controller.text = query;
      _controller.selection = TextSelection.collapsed(offset: query.length);
    }
    _effectiveFocusNode.unfocus();
    _saveRecentQuery(query);
    if (byIcon && widget.onSearchPressed != null) {
      widget.onSearchPressed!(query);
      return;
    }

    widget.onSubmitted?.call(query);
  }

  void _saveRecentQuery(String query) {
    final nextQueries = [
      query,
      ..._recentQueries.where((item) => item != query),
    ].take(5).toList(growable: false);

    _writeRecentQueries(nextQueries);
    if (mounted) {
      setState(() => _recentQueries = nextQueries);
      _suggestionOverlayEntry?.markNeedsBuild();
    }
  }

  void _removeRecentQuery(String query) {
    final nextQueries = _recentQueries
        .where((item) => item != query)
        .toList(growable: false);
    _writeRecentQueries(nextQueries);
    setState(() => _recentQueries = nextQueries);
    _suggestionOverlayEntry?.markNeedsBuild();
  }

  void _clearRecentQueries() {
    WebStorage.remove(_recentSearchStorageKey);
    setState(() => _recentQueries = const []);
    _suggestionOverlayEntry?.markNeedsBuild();
  }

  List<String> _readRecentQueries() {
    final value = WebStorage.read(_recentSearchStorageKey);
    if (value == null || value.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<String>()
          .map((query) => query.trim())
          .where((query) => query.isNotEmpty)
          .take(5)
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  void _writeRecentQueries(List<String> queries) {
    if (queries.isEmpty) {
      WebStorage.remove(_recentSearchStorageKey);
      return;
    }

    WebStorage.write(_recentSearchStorageKey, jsonEncode(queries));
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

  void _syncFocusState() {
    final nextValue = _effectiveFocusNode.hasFocus;
    if (_isFocused == nextValue) {
      return;
    }

    if (nextValue) {
      _showSuggestionsOverlay();
    } else {
      _hideSuggestionsOverlay();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isFocused != nextValue) {
        setState(() => _isFocused = nextValue);
        if (nextValue) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    });
  }

  void _showSuggestionsOverlay() {
    if (_suggestionOverlayEntry != null) {
      _suggestionOverlayEntry?.markNeedsBuild();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_effectiveFocusNode.hasFocus ||
          _suggestionOverlayEntry != null) {
        return;
      }

      final overlay = Overlay.maybeOf(context);
      final renderBox =
          _searchBarKey.currentContext?.findRenderObject() as RenderBox?;
      if (overlay == null || renderBox == null || !renderBox.hasSize) {
        return;
      }

      _suggestionOverlayEntry = OverlayEntry(
        builder: (context) {
          final renderBox =
              _searchBarKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox == null || !renderBox.hasSize) {
            return const SizedBox.shrink();
          }

          final offset = renderBox.localToGlobal(Offset.zero);
          return Positioned(
            left: offset.dx,
            top: offset.dy + renderBox.size.height + 8,
            width: renderBox.size.width,
            child: TextFieldTapRegion(child: _buildSuggestionPanel()),
          );
        },
      );
      overlay.insert(_suggestionOverlayEntry!);
    });
  }

  void _hideSuggestionsOverlay() {
    _suggestionOverlayEntry?.remove();
    _suggestionOverlayEntry = null;
  }

  Widget _buildSuggestionPanel() {
    return _SearchSuggestionPanel(
      keywords: widget.suggestionKeywords,
      recentQueries: _recentQueries,
      products: widget.recommendedProducts.take(2).toList(),
      onKeywordPressed: _submitQuery,
      onRecentQueryPressed: _submitQuery,
      onRecentQueryDeleted: _removeRecentQuery,
      onRecentQueriesCleared: _clearRecentQueries,
      onProductPressed: (product) => _submitQuery(product.name),
    );
  }
}

class _SearchSuggestionPanel extends StatelessWidget {
  const _SearchSuggestionPanel({
    required this.keywords,
    required this.recentQueries,
    required this.products,
    required this.onKeywordPressed,
    required this.onRecentQueryPressed,
    required this.onRecentQueryDeleted,
    required this.onRecentQueriesCleared,
    required this.onProductPressed,
  });

  final List<String> keywords;
  final List<String> recentQueries;
  final List<HomeProductData> products;
  final ValueChanged<String> onKeywordPressed;
  final ValueChanged<String> onRecentQueryPressed;
  final ValueChanged<String> onRecentQueryDeleted;
  final VoidCallback onRecentQueriesCleared;
  final ValueChanged<HomeProductData> onProductPressed;

  @override
  Widget build(BuildContext context) {
    final visibleKeywords = keywords
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .take(6)
        .toList();

    return Material(
      color: Colors.transparent,
      elevation: 14,
      shadowColor: const Color(0x1F0F172A),
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PanelSectionTitle(
                title: '연관 검색어',
                trailing: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (visibleKeywords.isEmpty)
                const _PanelEmptyRow(message: '연관 검색어 API 연결 대기 중')
              else
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final keyword in visibleKeywords)
                      _KeywordChip(
                        label: keyword,
                        onPressed: () => onKeywordPressed(keyword),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              _PanelSectionTitle(
                title: '최근 검색',
                trailing: recentQueries.isEmpty
                    ? null
                    : TextButton.icon(
                        onPressed: onRecentQueriesCleared,
                        icon: const Icon(Icons.delete_outline, size: 14),
                        label: const Text('전체 삭제'),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.textTertiary,
                          textStyle: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (recentQueries.isEmpty)
                const _PanelEmptyRow(message: '최근 검색어가 없습니다.')
              else
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final query in recentQueries)
                      _RecentSearchChip(
                        label: query,
                        onPressed: () => onRecentQueryPressed(query),
                        onDeleted: () => onRecentQueryDeleted(query),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              const _PanelSectionTitle(title: '인기 검색'),
              const SizedBox(height: AppSpacing.sm),
              const _PanelEmptyRow(message: '인기 검색 API 연결 대기 중'),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              const _PanelSectionTitle(title: '추천 상품'),
              const SizedBox(height: AppSpacing.sm),
              if (products.isEmpty)
                const _PanelEmptyRow(message: '추천상품 API 연결 대기 중')
              else
                for (final (index, product) in products.indexed)
                  _SuggestedProductTile(
                    key: ValueKey('search-suggestion-product-$index'),
                    product: product,
                    onPressed: () => onProductPressed(product),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelSectionTitle extends StatelessWidget {
  const _PanelSectionTitle({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _PanelEmptyRow extends StatelessWidget {
  const _PanelEmptyRow({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
      visualDensity: VisualDensity.standard,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _RecentSearchChip extends StatelessWidget {
  const _RecentSearchChip({
    required this.label,
    required this.onPressed,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: const Icon(
        Icons.access_time,
        size: 14,
        color: AppColors.textTertiary,
      ),
      label: Text(label),
      onPressed: onPressed,
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 14),
      visualDensity: VisualDensity.compact,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      deleteIconColor: AppColors.textTertiary,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _SuggestedProductTile extends StatelessWidget {
  const _SuggestedProductTile({
    required this.product,
    required this.onPressed,
    super.key,
  });

  final HomeProductData product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final rtiLabel = product.rtiLabel.isEmpty ? 'RTI 확인 중' : product.rtiLabel;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.label.isEmpty ? '신뢰도 분석 상품' : product.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rtiLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.priceLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
