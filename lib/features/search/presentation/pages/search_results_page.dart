import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/data/mock_search_results.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    final state = mockSearchResultsFor(query);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _SearchHeader(
              query: state.query,
              onSearchSubmitted: (value) => _goToSearch(context, value),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1280,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xl,
                AppSpacing.xxxl,
              ),
              child: _SearchResultsBody(state: state),
            ),
          ),
        ],
      ),
    );
  }

  void _goToSearch(BuildContext context, String value) {
    final nextQuery = value.trim();
    if (nextQuery.isEmpty) {
      return;
    }

    context.goNamed(RouteNames.search, queryParameters: {'q': nextQuery});
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.query, required this.onSearchSubmitted});

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: context.isMobile
              ? _MobileSearchHeader(
                  query: query,
                  onSearchSubmitted: onSearchSubmitted,
                )
              : _DesktopSearchHeader(
                  query: query,
                  onSearchSubmitted: onSearchSubmitted,
                ),
        ),
      ),
    );
  }
}

class _DesktopSearchHeader extends StatelessWidget {
  const _DesktopSearchHeader({
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    const navItems = [
      '홈',
      '브랜드데이',
      '베스트',
      '신상품',
      '타임딜',
      '리뷰 LIVE',
      '리뷰랭킹',
      '기획전',
      '선물하기',
      '반려동물',
      '여행/레저',
    ];

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 360,
              child: Row(
                children: [
                  HomeLogo(onTap: () => context.go(RoutePaths.home)),
                  const SizedBox(width: AppSpacing.xl),
                  _HeaderLink(label: '고객센터'),
                  const SizedBox(width: AppSpacing.lg),
                  _HeaderLink(label: '판매자 입점'),
                  const SizedBox(width: AppSpacing.lg),
                  _HeaderLink(label: '앱 다운로드'),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 520,
                  child: home.SearchBar(
                    initialValue: query,
                    onSubmitted: onSearchSubmitted,
                    onSearchPressed: onSearchSubmitted,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  _HeaderAction(icon: Icons.person_outline, label: '로그인'),
                  _HeaderAction(icon: Icons.favorite_border, label: '찜'),
                  _HeaderAction(
                    icon: Icons.shopping_cart_outlined,
                    label: '장바구니',
                    badge: '2',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '카테고리',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final item in navItems)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xl),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: item == '홈'
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileSearchHeader extends StatelessWidget {
  const _MobileSearchHeader({
    required this.query,
    required this.onSearchSubmitted,
  });

  final String query;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: () => context.go(RoutePaths.home)),
            const Spacer(),
            IconButton(
              tooltip: '홈',
              onPressed: () => context.go(RoutePaths.home),
              icon: const Icon(Icons.home_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        home.SearchBar(
          initialValue: query,
          onSubmitted: onSearchSubmitted,
          onSearchPressed: onSearchSubmitted,
        ),
      ],
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 24, color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge == null
              ? iconWidget
              : Badge(label: Text(badge!), child: iconWidget),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        height: 420,
        child: AppLoadingView(message: '검색 결과를 불러오는 중입니다.'),
      );
    }

    if (state.hasError) {
      return SizedBox(
        height: 420,
        child: AppErrorView(message: state.errorMessage!, retryLabel: '다시 검색'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchSummary(state: state),
        const SizedBox(height: AppSpacing.lg),
        _QuickFilterRow(filters: state.quickFilters),
        const SizedBox(height: AppSpacing.lg),
        if (state.isEmpty)
          SizedBox(
            height: 360,
            child: AppEmptyView(
              title: '검색 결과가 없어요',
              message: state.query.isEmpty
                  ? '상품명이나 카테고리를 입력하면 리뷰 기반 추천 상품을 보여드려요.'
                  : '다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.',
            ),
          )
        else if (context.isMobile)
          Column(
            children: [
              _FilterPanel(state: state, compact: true),
              const SizedBox(height: AppSpacing.md),
              _ResultColumn(state: state),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: _FilterPanel(state: state)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _ResultColumn(state: state)),
            ],
          ),
      ],
    );
  }
}

class _SearchSummary extends StatelessWidget {
  const _SearchSummary({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    final title = state.query.isEmpty
        ? '전체 상품 검색 결과'
        : '"${state.query}" 검색 결과';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.isMobile ? 24 : 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '총 ${state.displayTotalCount}개 상품 · RTI 신뢰 필터 적용 가능',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuickFilterRow extends StatelessWidget {
  const _QuickFilterRow({required this.filters});

  final List<SearchFilterChipData> filters;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                selected: filter.selected,
                label: Text(
                  filter.label == '전체' ? '전체 ${filter.count}' : filter.label,
                ),
                onSelected: (_) {},
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: filter.selected
                      ? AppColors.onPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
                side: BorderSide(
                  color: filter.selected ? AppColors.primary : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({required this.state, this.compact = false});

  final SearchResultsState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '필터',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('초기화')),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '카테고리',
              children: [
                for (final item in state.categoryFilters)
                  _CheckboxRow(
                    label: item.label,
                    trailing: '${item.count}',
                    selected: item.selected,
                  ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '가격대',
              children: [
                Row(
                  children: const [
                    Expanded(child: _PriceBox(label: '30,000')),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: Text('~'),
                    ),
                    Expanded(child: _PriceBox(label: '200,000')),
                    SizedBox(width: AppSpacing.xs),
                    Text('원'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final item in state.priceRanges)
                      _PriceRangeChip(
                        label: item.label,
                        selected: item.selected,
                      ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '브랜드',
              children: const [_SelectBox(label: '브랜드를 선택하세요')],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: 'RTI 신뢰 점수',
              trailing: '${state.selectedRtiMinimum}점 이상',
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                  ),
                  child: Slider(
                    value: state.selectedRtiMinimum.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 4,
                    onChanged: (_) {},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _ScaleLabel(label: '0'),
                    _ScaleLabel(label: '50'),
                    _ScaleLabel(label: '75'),
                    _ScaleLabel(label: '100'),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _FilterSection(
              title: '리뷰 조건',
              children: const [
                _CheckboxRow(label: '리뷰 50개 이상', selected: true),
                _CheckboxRow(label: '사진 포함'),
                _CheckboxRow(label: '최근 30일 리뷰 포함'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('초기화'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text('${state.displayTotalCount}개 결과 보기'),
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...children,
      ],
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.label,
    this.trailing,
    this.selected = false,
  });

  final String label;
  final String? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: Checkbox(value: selected, onChanged: (_) {}),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  const _PriceBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PriceRangeChip extends StatelessWidget {
  const _PriceRangeChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight : AppColors.surfaceMuted,
        borderRadius: AppRadius.small,
        border: Border.all(
          color: selected ? AppColors.primaryLight : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ResultColumn extends StatelessWidget {
  const _ResultColumn({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              '${state.displayTotalCount}개 결과',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            PopupMenuButton<SearchSortOption>(
              initialValue: state.sortOption,
              tooltip: '정렬',
              onSelected: (_) {},
              itemBuilder: (context) => [
                for (final option in SearchSortOption.values)
                  PopupMenuItem(value: option, child: Text(option.label)),
              ],
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderStrong),
                  borderRadius: AppRadius.small,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.sortOption.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.expand_more, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ProductGrid(products: state.products),
        const SizedBox(height: AppSpacing.lg),
        const _Pagination(),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<SearchResultProduct> products;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180
        ? 3
        : width >= 760
        ? 2
        : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: columns == 1 ? 430 : 430,
      ),
      itemBuilder: (context, index) {
        return _SearchProductCard(product: products[index]);
      },
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  const _SearchProductCard({required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    final rtiColor = _colorFromHex(product.rtiColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFBFF),
                        borderRadius: AppRadius.medium,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(color: AppColors.surfaceMuted),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _RtiBadge(
                      value: product.avgRti.round(),
                      color: rtiColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              mockBrandFor(product),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  product.avgRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '(리뷰 ${_formatCount(product.reviewCount)})',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _DeliveryBadge(label: mockBadgeFor(product)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatPrice(product.price),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SquareIconButton(
                  icon: Icons.favorite_border,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                _SquareIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: () {}, child: const Text('상품 상세 보기')),
          ],
        ),
      ),
    );
  }
}

class _RtiBadge extends StatelessWidget {
  const _RtiBadge({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_outlined, color: color, size: 16),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'RTI $value',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryBadge extends StatelessWidget {
  const _DeliveryBadge({required this.label});

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
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    const pages = ['1', '2', '3', '4', '5'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageButton(icon: Icons.chevron_left, selected: false),
        for (final page in pages)
          _PageButton(label: page, selected: page == '1'),
        _PageButton(icon: Icons.chevron_right, selected: false),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({this.label, this.icon, required this.selected});

  final String? label;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: SizedBox.square(
        dimension: 40,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: selected ? AppColors.primary : AppColors.surface,
            foregroundColor: selected
                ? AppColors.onPrimary
                : AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
          ),
          child: icon == null ? Text(label!) : Icon(icon, size: 18),
        ),
      ),
    );
  }
}

String _formatPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return '$buffer원';
}

String _formatCount(int count) {
  final digits = count.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

Color _colorFromHex(String hex) {
  final normalized = hex.replaceFirst('#', '');
  final value = int.tryParse('FF$normalized', radix: 16);
  if (value == null) {
    return AppColors.primary;
  }

  return Color(value);
}
