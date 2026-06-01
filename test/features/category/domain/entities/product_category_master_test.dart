import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';

void main() {
  test('defines the approved top-level product categories', () {
    expect(productCategoryTree, hasLength(14));
    expect(productCategoryTree.map((category) => category.label), [
      '디지털/가전',
      '패션의류',
      '패션잡화',
      '뷰티',
      '식품',
      '생활/주방',
      '가구/인테리어',
      '스포츠/레저',
      '자동차/공구',
      '출산/유아동',
      '반려동물',
      '도서/문구/취미',
      '여행/서비스',
      '명품/브랜드',
    ]);
  });

  test('keeps every top-level and middle category connected to children', () {
    for (final topLevelCategory in productCategoryTree) {
      expect(topLevelCategory.children, isNotEmpty);
      for (final middleCategory in topLevelCategory.children) {
        expect(
          middleCategory.children,
          isNotEmpty,
          reason: '${topLevelCategory.label} > ${middleCategory.label}',
        );
      }
    }
  });

  test('keeps category ids unique across the tree', () {
    final ids = <String>{};

    void collectIds(ProductCategory category) {
      expect(ids.add(category.id), isTrue, reason: category.id);
      for (final child in category.children) {
        collectIds(child);
      }
    }

    for (final category in productCategoryTree) {
      collectIds(category);
    }
  });

  test('provides lookup helpers for representative and detail categories', () {
    expect(productCategoryLabels, contains('프리미엄뷰티'));
    expect(
      productCategoryTree.findByLabel('디지털/가전')?.children.first.label,
      '모바일/태블릿',
    );
    expect(
      productCategoryTree
          .findByLabel('강아지용품')
          ?.children
          .map((category) => category.label),
      ['사료', '간식', '배변용품', '하네스', '장난감'],
    );
  });
}
