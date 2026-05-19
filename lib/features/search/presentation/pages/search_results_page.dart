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
              maxWidth: 1200,
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
        child: AppContentView(
          maxWidth: 1200,
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.md,
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.md,
          ),
          child: context.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    ),
                  ],
                )
              : Row(
                  children: [
                    HomeLogo(onTap: () => context.go(RoutePaths.home)),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(
                      child: home.SearchBar(
                        initialValue: query,
                        onSubmitted: onSearchSubmitted,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    TextButton.icon(
                      onPressed: () => context.go(RoutePaths.home),
                      icon: const Icon(Icons.home_outlined, size: 18),
                      label: const Text('홈으로'),
                    ),
                  ],
                ),
        ),
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
        _SearchToolbar(state: state),
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
        else
          _ProductGrid(products: state.products),
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
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '리뷰 신뢰도와 반복 패턴을 함께 보고 고를 수 있는 상품 ${state.totalCount}개',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SearchToolbar extends StatelessWidget {
  const _SearchToolbar({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final filter in state.filters)
              FilterChip(
                selected: filter.selected,
                label: Text('${filter.label} ${filter.count}'),
                onSelected: (_) {},
                selectedColor: AppColors.primaryLight,
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: filter.selected ? AppColors.primary : AppColors.border,
                ),
              ),
            const _ToolbarSpacer(),
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
                  border: Border.all(color: AppColors.borderStrong),
                  borderRadius: AppRadius.small,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, size: 18),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(state.sortOption.label),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarSpacer extends StatelessWidget {
  const _ToolbarSpacer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: context.isMobile ? 0 : AppSpacing.xl);
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
        mainAxisExtent: columns == 1 ? 250 : 420,
      ),
      itemBuilder: (context, index) {
        return _SearchProductCard(
          product: products[index],
          compact: columns == 1,
        );
      },
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  const _SearchProductCard({required this.product, required this.compact});

  final SearchResultProduct product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const ColoredBox(color: AppColors.surfaceMuted),
        ),
      ),
    );

    final info = _ProductInfo(product: product, compact: compact);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: compact
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 132, child: image),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: info),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: image),
                  const SizedBox(height: AppSpacing.md),
                  info,
                ],
              ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.compact});

  final SearchResultProduct product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (product.badge != null) _Badge(label: product.badge!),
            const Spacer(),
            Text(
              'RTI ${product.rtiScore}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${product.storeName} · ${product.category}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text(
              _formatPrice(product.price),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatPrice(product.originalPrice!),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textTertiary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product.summary,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

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
          ),
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
