class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.label,
    this.children = const [],
  });

  final String id;
  final String label;
  final List<ProductCategory> children;
}

extension ProductCategoryListLookup on List<ProductCategory> {
  ProductCategory? findByLabel(String label) {
    for (final category in this) {
      if (category.label == label) {
        return category;
      }

      final child = category.children.findByLabel(label);
      if (child != null) {
        return child;
      }
    }

    return null;
  }

  List<String> flattenLabels() {
    return [
      for (final category in this) ...[
        category.label,
        ...category.children.flattenLabels(),
      ],
    ];
  }
}
