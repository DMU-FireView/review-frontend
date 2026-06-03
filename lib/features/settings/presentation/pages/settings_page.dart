import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _minReviewController;
  late final TextEditingController _lowRtiController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsViewModelProvider);
    final data = _dataFrom(settings);
    _minReviewController = TextEditingController(
      text: data.minReviewCount.toString(),
    );
    _lowRtiController = TextEditingController(
      text: data.lowRtiThreshold.toString(),
    );

    Future.microtask(() {
      ref.read(myPageViewModelProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _minReviewController.dispose();
    _lowRtiController.dispose();
    super.dispose();
  }

  SettingsData _dataFrom(SettingsState s) => switch (s) {
    SettingsIdle(:final settings) => settings,
    SettingsSaving(:final settings) => settings,
    SettingsSaved(:final settings) => settings,
    SettingsError(:final settings) => settings,
  };

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final settingsState = ref.watch(settingsViewModelProvider);
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final myPageState = ref.watch(myPageViewModelProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final cartCount = ref.watch(cartItemCountProvider).value ?? 0;
    final wishlistCount = ref.watch(wishlistItemCountProvider).value ?? 0;

    final profile = switch (myPageState) {
      MyPageSuccess(:final profile) => profile,
      _ => null,
    };

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
              cartCount: cartCount,
              wishlistCount: wishlistCount,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onNavItemPressed: (_) => context.go(RoutePaths.home),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: _handleSearchSubmitted,
              searchKeywords: _keywordsFrom(dashboardState),
              searchRecommendedProducts: _productsFrom(dashboardState),
              onSearchSuggestionsRequested: _handleSearchSuggestionsRequested,
              onMyPagePressed: () => context.go(RoutePaths.myPage),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: _handleLogout,
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
              child: _SettingsBody(
                settingsState: settingsState,
                profile: profile,
                minReviewController: _minReviewController,
                lowRtiController: _lowRtiController,
                onEmailNotificationChanged: (v) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setEmailNotification(v),
                onPushNotificationChanged: (v) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setPushNotification(v),
                onAdEmailChanged: (v) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setAdEmailNotification(v),
                onHighlightLowRtiChanged: (v) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setHighlightLowRti(v),
                onWishlistAlertChanged: (v) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setWishlistAlert(v),
                onCategoryChanged: (id, label) => ref
                    .read(settingsViewModelProvider.notifier)
                    .setCategoryFilter(id, label),
                onMinReviewCountChanged: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed >= 0) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .setMinReviewCount(parsed);
                  }
                },
                onLowRtiThresholdChanged: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed >= 0 && parsed <= 100) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .setLowRtiThreshold(parsed);
                  }
                },
                onSave: () =>
                    ref.read(settingsViewModelProvider.notifier).save(),
                onMyPageTap: () => context.go(RoutePaths.myPage),
                onCartTap: () => context.go(RoutePaths.cart),
                onWishlistTap: () => context.go(RoutePaths.wishlist),
                onPasswordTap: () => context.go(RoutePaths.passwordReset),
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

  void _handleSearchSubmitted(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.goNamed(RouteNames.search, queryParameters: {'q': query});
  }

  void _handleLogout() {
    ref.read(authTokenStoreProvider.notifier).clear();
    context.go(RoutePaths.landing);
  }

  List<String> _keywordsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.trendingKeywords.map((k) => k.keyword).toList(),
      _ => const [],
    };
  }

  List<HomeProductData> _productsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.recommendedProducts.map(_toHomeProductData).toList(),
      _ => const [],
    };
  }

  HomeProductData _toHomeProductData(DashboardProduct product) {
    return HomeProductData(
      productId: product.id,
      name: product.name,
      storeName: product.storeName,
      priceLabel: _formatPrice(product.price),
      ratingLabel: product.rating?.toStringAsFixed(1) ?? '-',
      reviewCountLabel: product.reviewCount?.toString() ?? '-',
      rtiLabel: product.rtiScore == null ? '' : 'RTI ${product.rtiScore}',
      imageUrl: product.imageUrl,
      label: product.label ?? '',
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settingsState,
    required this.profile,
    required this.minReviewController,
    required this.lowRtiController,
    required this.onEmailNotificationChanged,
    required this.onPushNotificationChanged,
    required this.onAdEmailChanged,
    required this.onHighlightLowRtiChanged,
    required this.onWishlistAlertChanged,
    required this.onCategoryChanged,
    required this.onMinReviewCountChanged,
    required this.onLowRtiThresholdChanged,
    required this.onSave,
    required this.onMyPageTap,
    required this.onCartTap,
    required this.onWishlistTap,
    required this.onPasswordTap,
  });

  final SettingsState settingsState;
  final UserProfile? profile;
  final TextEditingController minReviewController;
  final TextEditingController lowRtiController;
  final ValueChanged<bool> onEmailNotificationChanged;
  final ValueChanged<bool> onPushNotificationChanged;
  final ValueChanged<bool> onAdEmailChanged;
  final ValueChanged<bool> onHighlightLowRtiChanged;
  final ValueChanged<bool> onWishlistAlertChanged;
  final void Function(String? id, String? label) onCategoryChanged;
  final ValueChanged<String> onMinReviewCountChanged;
  final ValueChanged<String> onLowRtiThresholdChanged;
  final VoidCallback onSave;
  final VoidCallback onMyPageTap;
  final VoidCallback onCartTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onPasswordTap;

  @override
  Widget build(BuildContext context) {
    final data = switch (settingsState) {
      SettingsIdle(:final settings) => settings,
      SettingsSaving(:final settings) => settings,
      SettingsSaved(:final settings) => settings,
      SettingsError(:final settings) => settings,
    };

    final isSaving = settingsState is SettingsSaving;
    final isSaved = settingsState is SettingsSaved;

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NotificationSection(
          data: data,
          onEmailChanged: onEmailNotificationChanged,
          onPushChanged: onPushNotificationChanged,
          onAdEmailChanged: onAdEmailChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        _FilterSection(
          data: data,
          minReviewController: minReviewController,
          lowRtiController: lowRtiController,
          onHighlightLowRtiChanged: onHighlightLowRtiChanged,
          onWishlistAlertChanged: onWishlistAlertChanged,
          onCategoryChanged: onCategoryChanged,
          onMinReviewCountChanged: onMinReviewCountChanged,
          onLowRtiThresholdChanged: onLowRtiThresholdChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        _SaveBar(
          isSaving: isSaving,
          isSaved: isSaved,
          onSave: onSave,
        ),
      ],
    );

    final rightPanel = _AccountPanel(
      profile: profile,
      onPasswordTap: onPasswordTap,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageTitle(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        if (context.viewportSize.width < 980) ...[
          _SideNavCard(
            onMyPageTap: onMyPageTap,
            onCartTap: onCartTap,
            onWishlistTap: onWishlistTap,
          ),
          const SizedBox(height: AppSpacing.xl),
          mainContent,
          const SizedBox(height: AppSpacing.xl),
          rightPanel,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: _SideNavCard(
                  onMyPageTap: onMyPageTap,
                  onCartTap: onCartTap,
                  onWishlistTap: onWishlistTap,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                flex: 3,
                child: mainContent,
              ),
              const SizedBox(width: AppSpacing.xl),
              SizedBox(
                width: 280,
                child: rightPanel,
              ),
            ],
          ),
      ],
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () => context.go(RoutePaths.home),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text('홈'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            TextButton(
              onPressed: () => context.go(RoutePaths.myPage),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text('마이페이지'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            Text(
              '설정',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              '설정',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              profile != null
                  ? '${profile!.nickname}님의 알림, 필터, 계정 설정을 관리해요.'
                  : '알림, 필터, 계정 설정을 관리해요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SideNavCard extends StatelessWidget {
  const _SideNavCard({
    required this.onMyPageTap,
    required this.onCartTap,
    required this.onWishlistTap,
  });

  final VoidCallback onMyPageTap;
  final VoidCallback onCartTap;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          _SideNavItem(
            icon: Icons.home_outlined,
            label: '마이페이지',
            onTap: onMyPageTap,
          ),
          _SideNavItem(
            icon: Icons.inventory_2_outlined,
            label: '주문/배송',
            onTap: onCartTap,
          ),
          _SideNavItem(
            icon: Icons.favorite_border,
            label: '저장한 상품',
            onTap: onWishlistTap,
          ),
          _SideNavItem(
            icon: Icons.history,
            label: '최근 본 상품',
            onTap: onWishlistTap,
          ),
          _SideNavItem(
            icon: Icons.rate_review_outlined,
            label: '리뷰 활동',
            onTap: onMyPageTap,
          ),
          _SideNavItem(
            icon: Icons.settings_outlined,
            label: '계정 설정',
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    left: BorderSide(color: AppColors.primary, width: 3),
                  )
                : null,
          ),
          padding: EdgeInsets.only(
            left: selected ? AppSpacing.lg - 3 : AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textPrimary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight:
                        selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({
    required this.data,
    required this.onEmailChanged,
    required this.onPushChanged,
    required this.onAdEmailChanged,
  });

  final SettingsData data;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onAdEmailChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '알림 설정',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          _SettingToggleRow(
            label: '이메일 알림 받기',
            description: '상품 가격 변동, 리뷰 업데이트 알림을 이메일로 받아요.',
            value: data.emailNotification,
            onChanged: onEmailChanged,
          ),
          const Divider(color: AppColors.border, height: 1),
          _SettingToggleRow(
            label: '앱 푸시 알림 받기',
            description: '저장한 상품의 실시간 알림을 브라우저에서 받아요.',
            value: data.pushNotification,
            onChanged: onPushChanged,
          ),
          const Divider(color: AppColors.border, height: 1),
          _SettingToggleRow(
            label: '이메일 광고 수신',
            description: '프로모션 및 맞춤 혜택 정보를 이메일로 받아요.',
            value: data.adEmailNotification,
            onChanged: onAdEmailChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.data,
    required this.minReviewController,
    required this.lowRtiController,
    required this.onHighlightLowRtiChanged,
    required this.onWishlistAlertChanged,
    required this.onCategoryChanged,
    required this.onMinReviewCountChanged,
    required this.onLowRtiThresholdChanged,
  });

  final SettingsData data;
  final TextEditingController minReviewController;
  final TextEditingController lowRtiController;
  final ValueChanged<bool> onHighlightLowRtiChanged;
  final ValueChanged<bool> onWishlistAlertChanged;
  final void Function(String? id, String? label) onCategoryChanged;
  final ValueChanged<String> onMinReviewCountChanged;
  final ValueChanged<String> onLowRtiThresholdChanged;

  @override
  Widget build(BuildContext context) {
    final topCategories = productCategoryTree
        .map((c) => (id: c.id, label: c.label))
        .toList();

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '분석 필터 설정',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          _SettingToggleRow(
            label: '주의 상품 먼저 보기',
            description: '리뷰 신뢰도가 낮은 상품을 목록 상단에 표시해요.',
            value: data.highlightLowRti,
            onChanged: onHighlightLowRtiChanged,
          ),
          const Divider(color: AppColors.border, height: 1),
          _SettingToggleRow(
            label: '저장 상품 알림 받기',
            description: '관심 상품의 RTI 변화가 있을 때 알림을 드려요.',
            value: data.wishlistAlert,
            onChanged: onWishlistAlertChanged,
          ),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          _CategoryFilterRow(
            selectedId: data.categoryFilterId,
            selectedLabel: data.categoryFilterLabel,
            categories: topCategories,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _NumberInputRow(
            label: '리뷰 최소 개수',
            description: '이 개수 이상 리뷰가 있는 상품만 분석 결과에 반영해요.',
            controller: minReviewController,
            unit: '개',
            onChanged: onMinReviewCountChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _NumberInputRow(
            label: '낮은 RTI 경고 기준',
            description: 'RTI 점수가 이 값 이하면 주의 상품으로 분류해요.',
            controller: lowRtiController,
            unit: '점',
            onChanged: onLowRtiThresholdChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingToggleRow extends StatelessWidget {
  const _SettingToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.selectedId,
    required this.selectedLabel,
    required this.categories,
    required this.onChanged,
  });

  final String? selectedId;
  final String? selectedLabel;
  final List<({String id, String label})> categories;
  final void Function(String? id, String? label) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리 필터',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '선택한 카테고리 상품을 기준으로 분석 결과를 우선 표시해요.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          value: selectedId,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            isDense: true,
          ),
          hint: const Text('전체 카테고리'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('전체 카테고리'),
            ),
            for (final cat in categories)
              DropdownMenuItem<String>(
                value: cat.id,
                child: Text(cat.label),
              ),
          ],
          onChanged: (id) {
            final label = id == null
                ? null
                : categories.firstWhere((c) => c.id == id).label;
            onChanged(id, label);
          },
        ),
      ],
    );
  }
}

class _NumberInputRow extends StatelessWidget {
  const _NumberInputRow({
    required this.label,
    required this.description,
    required this.controller,
    required this.unit,
    required this.onChanged,
  });

  final String label;
  final String description;
  final TextEditingController controller;
  final String unit;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 180,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              suffixText: unit,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.isSaving,
    required this.isSaved,
    required this.onSave,
  });

  final bool isSaving;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isSaved)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '설정이 저장되었습니다.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        FilledButton(
          onPressed: isSaving ? null : onSave,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
          ),
          child: isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : const Text('저장'),
        ),
      ],
    );
  }
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel({
    required this.profile,
    required this.onPasswordTap,
  });

  final UserProfile? profile;
  final VoidCallback onPasswordTap;

  @override
  Widget build(BuildContext context) {
    final createdAt = profile?.createdAt;
    final joinDateLabel = createdAt != null
        ? '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}'
        : '-';

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '계정',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: onPasswordTap,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  minimumSize: Size.zero,
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('비밀번호 변경'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: '이름',
            value: profile?.nickname.isEmpty ?? true
                ? '사용자'
                : profile!.nickname,
          ),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(label: '이메일', value: profile?.email ?? '-'),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(label: '가입일', value: joinDateLabel),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            label: '회원 유형',
            value: profile?.role.isEmpty ?? true
                ? '일반 회원'
                : '${profile!.role} 회원',
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '연동 서비스',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _ServiceRow(
            label: '네이버 쇼핑',
            statusLabel: '연동됨',
            statusColor: AppColors.success,
          ),
          _ServiceRow(
            label: '쿠팡',
            statusLabel: '연동됨',
            statusColor: AppColors.success,
          ),
          _ServiceRow(
            label: '11번가',
            statusLabel: '미연동',
            statusColor: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.label,
    required this.statusLabel,
    required this.statusColor,
  });

  final String label;
  final String statusLabel;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            statusLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}

String _formatPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$buffer원';
}
