import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
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
                      ? Image.network(
                          images[_selectedIndex],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: AppColors.surfaceMuted),
                        )
                      : const ColoredBox(color: AppColors.surfaceMuted),
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
                        ? () => setState(() => _selectedIndex--)
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
                        ? () => setState(() => _selectedIndex++)
                        : null,
                  ),
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
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
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
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: AppColors.surfaceMuted),
                        ),
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
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8),
        ],
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
  const _GalleryArrowButton({
    required this.icon,
    required this.onPressed,
  });

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
