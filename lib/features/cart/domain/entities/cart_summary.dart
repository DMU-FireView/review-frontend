class CartSummary {
  const CartSummary({
    required this.totalProductPrice,
    required this.shippingFee,
    required this.discountAmount,
    required this.totalPayment,
    this.expectedPoint = 0,
    this.appliedCouponName,
    this.appliedCouponDiscount = 0,
  });

  final int totalProductPrice;
  final int shippingFee;
  final int discountAmount;
  final int totalPayment;
  final int expectedPoint;
  final String? appliedCouponName;
  final int appliedCouponDiscount;

  bool get isFreeShipping => shippingFee == 0;
}
