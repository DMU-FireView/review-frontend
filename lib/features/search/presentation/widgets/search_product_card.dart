import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/data/mock_search_results.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class SearchProductCard extends StatelessWidget {
  const SearchProductCard({super.key, required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    final rtiColor = colorFromHex(product.rtiColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppNetworkImage(
                      url: product.imageUrl,
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: RtiBadge(
                      value: product.avgRti.round(),
                      color: rtiColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              mockBrandFor(product),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              product.name,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                height: 1.22,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      product.avgRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '(리뷰 ${formatSearchCount(product.reviewCount)})',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                DeliveryBadge(label: mockBadgeFor(product)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final chip in mockTraitChipsFor(product))
                  ProductTraitChip(label: chip),
              ],
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatSearchPrice(product.price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                SquareIconButton(icon: Icons.favorite_border, onPressed: () {}),
                const SizedBox(width: AppSpacing.xs),
                SquareIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: ProductDetailButton(
                    onPressed: () => context.goNamed(
                      RouteNames.productDetail,
                      pathParameters: {'id': product.id.toString()},
                    ),
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

class SearchProductListTile extends StatelessWidget {
  const SearchProductListTile({super.key, required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    final rtiColor = colorFromHex(product.rtiColor);
    final isCompact = MediaQuery.sizeOf(context).width < 760;
    final image = SizedBox(
      width: isCompact ? 120 : 188,
      height: isCompact ? 92 : 126,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppNetworkImage(
              url: product.imageUrl,
              borderRadius: AppRadius.medium,
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: RtiBadge(value: product.avgRti.round(), color: rtiColor),
          ),
        ],
      ),
    );
    final details = ListTileDetails(product: product);
    final actions = ListTileActions(product: product, compact: isCompact);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      image,
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: details),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  actions,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  image,
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: details),
                  const SizedBox(width: AppSpacing.md),
                  actions,
                ],
              ),
      ),
    );
  }
}

class ListTileDetails extends StatelessWidget {
  const ListTileDetails({super.key, required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mockBrandFor(product),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            height: 1.25,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  product.avgRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '(리뷰 ${formatSearchCount(product.reviewCount)})',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            DeliveryBadge(label: mockBadgeFor(product)),
            for (final chip in mockTraitChipsFor(product))
              ProductTraitChip(label: chip),
          ],
        ),
      ],
    );
  }
}

class ListTileActions extends StatelessWidget {
  const ListTileActions({
    super.key,
    required this.product,
    required this.compact,
  });

  final SearchResultProduct product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? double.infinity : 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            formatSearchPrice(product.price),
            textAlign: compact ? TextAlign.left : TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              SquareIconButton(icon: Icons.favorite_border, onPressed: () {}),
              const SizedBox(width: AppSpacing.xs),
              SquareIconButton(
                icon: Icons.shopping_cart_outlined,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Builder(
            builder: (context) => ProductDetailButton(
              onPressed: () => context.goNamed(
                RouteNames.productDetail,
                pathParameters: {'id': product.id.toString()},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RtiBadge extends StatelessWidget {
  const RtiBadge({super.key, required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_outlined, color: color, size: 14),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'RTI $value',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryBadge extends StatelessWidget {
  const DeliveryBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class ProductTraitChip extends StatelessWidget {
  const ProductTraitChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: outlineHoverButtonStyle(padding: EdgeInsets.zero),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class ProductDetailButton extends StatelessWidget {
  const ProductDetailButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: outlineHoverButtonStyle(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
        child: Text(
          '상품 상세 보기',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

ButtonStyle outlineHoverButtonStyle({required EdgeInsetsGeometry padding}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all(padding),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primaryLight
          : AppColors.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primary
          : AppColors.textPrimary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      return BorderSide(
        color: states.contains(WidgetState.hovered)
            ? AppColors.primary
            : AppColors.borderStrong,
      );
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.small),
    ),
  );
}
