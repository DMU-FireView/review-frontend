import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (widget.imageUrls.length <= 1) return;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % widget.imageUrls.length;
      });
    });
  }

  void _goTo(int index) {
    _autoSlideTimer?.cancel();
    setState(() => _selectedIndex = index);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: images.isNotEmpty
                  ? () =>
                        _showProductImageDialog(context, images, _selectedIndex)
                  : null,
              child: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: AppRadius.large,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.large,
                    child: _selectedIndex < images.length
                        ? AppNetworkImage(url: images[_selectedIndex])
                        : const ColoredBox(color: AppColors.surfaceMuted),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _WishlistButton(),
            ),
            if (images.length > 1) ...[
              Positioned(
                left: AppSpacing.xs,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _GalleryArrowButton(
                    icon: Icons.chevron_left,
                    onPressed: _selectedIndex > 0
                        ? () => _goTo(_selectedIndex - 1)
                        : null,
                  ),
                ),
              ),
              Positioned(
                right: AppSpacing.xs,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _GalleryArrowButton(
                    icon: Icons.chevron_right,
                    onPressed: _selectedIndex < images.length - 1
                        ? () => _goTo(_selectedIndex + 1)
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _IndexIndicator(
                  current: _selectedIndex + 1,
                  total: images.length,
                ),
              ),
            ],
          ],
        ),
        if (images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => _goTo(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: AppRadius.small,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.small,
                      child: SizedBox.square(
                        dimension: 66,
                        child: AppNetworkImage(url: images[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _IndexIndicator extends StatelessWidget {
  const _IndexIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          '$current / $total',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _WishlistButton extends StatefulWidget {
  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8)],
      ),
      child: SizedBox.square(
        dimension: 40,
        child: IconButton(
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: _isFavorite ? Colors.red : AppColors.textSecondary,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _GalleryArrowButton extends StatelessWidget {
  const _GalleryArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: SizedBox.square(
        dimension: 32,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          padding: EdgeInsets.zero,
          color: onPressed != null
              ? AppColors.textPrimary
              : AppColors.textTertiary,
        ),
      ),
    );
  }
}

void _showProductImageDialog(
  BuildContext context,
  List<String> imageUrls,
  int initialIndex,
) {
  showDialog<void>(
    context: context,
    builder: (_) =>
        _ProductImageDialog(imageUrls: imageUrls, initialIndex: initialIndex),
  );
}

class _ProductImageDialog extends StatefulWidget {
  const _ProductImageDialog({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<_ProductImageDialog> createState() => _ProductImageDialogState();
}

class _ProductImageDialogState extends State<_ProductImageDialog> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black54),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 680,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: AppNetworkImage(
                      url: widget.imageUrls[_current],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (widget.imageUrls.length > 1) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DialogNavButton(
                        icon: Icons.chevron_left,
                        enabled: _current > 0,
                        onTap: () => setState(() => _current--),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '${_current + 1} / ${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _DialogNavButton(
                        icon: Icons.chevron_right,
                        enabled: _current < widget.imageUrls.length - 1,
                        onTap: () => setState(() => _current++),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black45,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogNavButton extends StatelessWidget {
  const _DialogNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: enabled
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.08),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.white38,
          size: 22,
        ),
      ),
    );
  }
}
