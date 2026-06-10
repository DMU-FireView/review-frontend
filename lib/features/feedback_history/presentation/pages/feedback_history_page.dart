import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';
import 'package:re_view_front/features/feedback_history/presentation/providers/feedback_history_providers.dart';
import 'package:re_view_front/features/feedback_history/presentation/view_models/feedback_history_state.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class FeedbackHistoryPage extends ConsumerStatefulWidget {
  const FeedbackHistoryPage({super.key});

  @override
  ConsumerState<FeedbackHistoryPage> createState() =>
      _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends ConsumerState<FeedbackHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(feedbackHistoryViewModelProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackHistoryViewModelProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onNavItemPressed: (_) => context.go(RoutePaths.home),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              searchKeywords: const [],
              searchRecommendedProducts: const [],
              onSearchSuggestionsRequested: _handleSearchSuggestionsRequested,
              onMyPagePressed: () =>
                  context.go(isLoggedIn ? RoutePaths.myPage : RoutePaths.login),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: () {
                ref.read(authTokenStoreProvider.notifier).clear();
                context.go(RoutePaths.landing);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1320,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(onBack: () => context.go(RoutePaths.myPage)),
                  const SizedBox(height: AppSpacing.xl),
                  switch (state) {
                    FeedbackHistoryInitial() ||
                    FeedbackHistoryLoading() =>
                      SizedBox(
                        height: 320,
                        child: AppLoadingView(
                          message: AppLocalizations.of(context).feedbackHistoryLoading,
                        ),
                      ),
                    FeedbackHistoryFailure(:final failure) => SizedBox(
                      height: 320,
                      child: AppErrorView(
                        message: failure.message,
                        onRetry: () => ref
                            .read(feedbackHistoryViewModelProvider.notifier)
                            .load(),
                      ),
                    ),
                    FeedbackHistoryEmpty() => _EmptyBody(
                      onGoHome: () => context.go(RoutePaths.home),
                    ),
                    FeedbackHistorySuccess(:final items) => _FeedbackList(
                      items: items,
                      onProductTap: (productId) => context.goNamed(
                        RouteNames.productDetail,
                        pathParameters: {'id': productId.toString()},
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _handleSearchSuggestionsRequested(String query) {
    return ref
        .read(searchAutocompleteRemoteDataSourceProvider)
        .fetchSuggestions(query);
  }

