import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

class CartOrderSummary extends StatefulWidget {
  const CartOrderSummary({
    super.key,
    required this.summary,
    required this.selectedCount,
    required this.onCheckout,
    required this.onContinueShopping,
  });

  final CartSummary summary;
  final int selectedCount;
  final Future<void> Function() onCheckout;
  final VoidCallback onContinueShopping;

  @override
  State<CartOrderSummary> createState() => _CartOrderSummaryState();
}

class _CartOrderSummaryState extends State<CartOrderSummary> {
  bool _isCheckingOut = false;

  Future<void> _handleCheckout() async {
    if (_isCheckingOut) return;
    setState(() => _isCheckingOut = true);
    try {
      await widget.onCheckout();
    } finally {
      if (mounted) setState(() => _isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final selectedCount = widget.selectedCount;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '주문 요약',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: '상품금액',
              value: formatSearchPrice(summary.totalProductPrice),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: '배송비',
              value: summary.isFreeShipping ? '0원' : formatSearchPrice(summary.shippingFee),
              valueBadge: summary.isFreeShipping ? '무료배송' : null,
            ),
            if (summary.discountAmount > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow(
                label: '할인금액',
                value: '-${formatSearchPrice(summary.discountAmount)}',
                valueColor: AppColors.error,
              ),
            ],
            if (summary.appliedCouponName != null) ...[
              const SizedBox(height: AppSpacing.xs),
              _CouponRow(
                couponName: summary.appliedCouponName!,
                discount: summary.appliedCouponDiscount,
              ),
            ],
            if (summary.expectedPoint > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow(
                label: '예상 적립 포인트',
                value: '${summary.expectedPoint}P',
                valueColor: AppColors.primary,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 결제금액',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  formatSearchPrice(summary.totalPayment),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed:
                    (selectedCount > 0 && !_isCheckingOut) ? _handleCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  disabledBackgroundColor: AppColors.textTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isCheckingOut
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        '주문하기 ($selectedCount)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.local_offer_outlined, size: 16),
                label: const Text('쿠폰함'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: widget.onContinueShopping,
              child: Text(
                '쇼핑 계속하기',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueBadge,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? valueBadge;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valueBadge != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    valueBadge!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CouponRow extends StatelessWidget {
  const _CouponRow({required this.couponName, required this.discount});

  final String couponName;
  final int discount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              child: Text(
                '$couponName -${formatSearchPrice(discount)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '쿠폰 변경',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
