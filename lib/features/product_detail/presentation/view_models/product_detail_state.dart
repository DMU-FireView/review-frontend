import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailSuccess extends ProductDetailState {
  const ProductDetailSuccess({
    required this.detail,
    required this.reviews,
    required this.reviewInsight,
    required this.similarProducts,
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
}

class ProductDetailFailure extends ProductDetailState {
  const ProductDetailFailure(this.failure);

  final Failure failure;
}
