import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/providers/locale_provider.dart';
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
import 'package:re_view_front/l10n/generated/app_localizations.dart';
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
    final data = _dataFrom(ref.read(settingsViewModelProvider));
    _minReviewController =
        TextEditingController(text: data.minReviewCount.toString());
    _lowRtiController =
        TextEditingController(text: data.lowRtiThreshold.toString());
    Future.microtask(() => ref.read(myPageViewModelProvider.notifier).load());
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
    final currentLocale = ref.watch(localeProvider);
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
                currentLocale: currentLocale,
                profile: profile,
                minReviewController: _minReviewController,
                lowRtiController: _lowRtiController,
                onLocaleChanged: (locale) =>
                    ref.read(localeProvider.notifier).setLocale(locale),
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
                  final n = int.tryParse(v);
                  if (n != null && n >= 0) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .setMinReviewCount(n);
                  }
                },
                onLowRtiThresholdChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null && n >= 0 && n <= 100) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .setLowRtiThreshold(n);
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
    final q = value.trim();
    if (q.isEmpty) return;
    context.goNamed(RouteNames.search, queryParameters: {'q': q});
  }

  void _handleLogout() {
    ref.read(authTokenStoreProvider.notifier).clear();
    context.go(RoutePaths.landing);
  }

  List<String> _keywordsFrom(HomeDashboardState state) => switch (state) {
    HomeDashboardSuccess(:final dashboard) =>
      dashboard.trendingKeywords.map((k) => k.keyword).toList(),
    _ => const [],
  };

  List<HomeProductData> _productsFrom(HomeDashboardState state) =>
      switch (state) {
        HomeDashboardSuccess(:final dashboard) =>
          dashboard.recommendedProducts.map(_toHomeProductData).toList(),
        _ => const [],
      };

  HomeProductData _toHomeProductData(DashboardProduct p) => HomeProductData(
    productId: p.id,
    name: p.name,
    storeName: p.storeName,
    priceLabel: _formatPrice(p.price),
    ratingLabel: p.rating?.toStringAsFixed(1) ?? '-',
    reviewCountLabel: p.reviewCount?.toString() ?? '-',
    rtiLabel: p.rtiScore == null ? '' : 'RTI ${p.rtiScore}',
    imageUrl: p.imageUrl,
    label: p.label ?? '',
  );
}

// ─────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settingsState,
    required this.currentLocale,
    required this.profile,
    required this.minReviewController,
    required this.lowRtiController,
    required this.onLocaleChanged,
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
  final Locale currentLocale;
  final UserProfile? profile;
  final TextEditingController minReviewController;
  final TextEditingController lowRtiController;
  final ValueChanged<Locale> onLocaleChanged;
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
        const SizedBox(height: AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.lg),
        _SaveBar(isSaving: isSaving, isSaved: isSaved, onSave: onSave),
      ],
    );

    // 우측 컬럼: 계정 카드 → 언어 설정
    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccountPanel(profile: profile, onPasswordTap: onPasswordTap),
        const SizedBox(height: AppSpacing.lg),
        _LanguageSection(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
      ],
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
          rightColumn,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 248,
                child: _SideNavCard(
                  onMyPageTap: onMyPageTap,
                  onCartTap: onCartTap,
                  onWishlistTap: onWishlistTap,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(flex: 3, child: mainContent),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(width: 272, child: rightColumn),
            ],
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Page title & breadcrumb
// ─────────────────────────────────────────────────────────────

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
            _Breadcrumb(label: AppLocalizations.of(context).navHome, onTap: () => context.go(RoutePaths.home)),
            const _BreadcrumbSep(),
            _Breadcrumb(
              label: AppLocalizations.of(context).navMyPage,
              onTap: () => context.go(RoutePaths.myPage),
            ),
            const _BreadcrumbSep(),
            Text(
              AppLocalizations.of(context).navSettings,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              AppLocalizations.of(context).navSettings,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              profile != null
                  ? AppLocalizations.of(context).settingsSubtitleNamed(profile!.nickname)
                  : AppLocalizations.of(context).settingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BreadcrumbSep extends StatelessWidget {
  const _BreadcrumbSep();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    child: Icon(Icons.chevron_right, size: 14, color: AppColors.textTertiary),
  );
}

// ─────────────────────────────────────────────────────────────
// Sidebar nav
// ─────────────────────────────────────────────────────────────

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
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xs),
          _NavItem(icon: Icons.home_outlined, label: AppLocalizations.of(context).navMyPage, onTap: onMyPageTap),
          _NavItem(icon: Icons.inventory_2_outlined, label: AppLocalizations.of(context).sideNavOrders, onTap: onCartTap),
          _NavItem(icon: Icons.favorite_border, label: AppLocalizations.of(context).navWishlist, onTap: onWishlistTap),
          _NavItem(icon: Icons.history, label: AppLocalizations.of(context).sideNavRecentlyViewed, onTap: onWishlistTap),
          _NavItem(icon: Icons.rate_review_outlined, label: AppLocalizations.of(context).sideNavReviewActivity, onTap: onMyPageTap),
          _NavItem(
            icon: Icons.settings_outlined,
            label: AppLocalizations.of(context).sideNavAccountSettings,
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
          height: 52,
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
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Notification section
// ─────────────────────────────────────────────────────────────

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
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFF6366F1),
            iconBg: const Color(0xFFEEF2FF),
            title: AppLocalizations.of(context).settingsNotifications,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToggleRow(
            icon: Icons.email_outlined,
            label: AppLocalizations.of(context).settingsNotificationEmail,
            description: AppLocalizations.of(context).settingsNotificationEmailDesc,
            value: data.emailNotification,
            onChanged: onEmailChanged,
          ),
          _ToggleRow(
            icon: Icons.phone_iphone_outlined,
            label: AppLocalizations.of(context).settingsNotificationPush,
            description: AppLocalizations.of(context).settingsNotificationPushDesc,
            value: data.pushNotification,
            onChanged: onPushChanged,
          ),
          _ToggleRow(
            icon: Icons.campaign_outlined,
            label: AppLocalizations.of(context).settingsNotificationAdEmail,
            description: AppLocalizations.of(context).settingsNotificationAdEmailDesc,
            value: data.adEmailNotification,
            onChanged: onAdEmailChanged,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Filter section
// ─────────────────────────────────────────────────────────────

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
    final topCategories =
        productCategoryTree.map((c) => (id: c.id, label: c.label)).toList();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.tune_outlined,
            iconColor: const Color(0xFF0891B2),
            iconBg: const Color(0xFFCFFAFE),
            title: AppLocalizations.of(context).settingsFilters,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToggleRow(
            icon: Icons.warning_amber_outlined,
            label: AppLocalizations.of(context).settingsFilterHighlightLowRti,
            description: AppLocalizations.of(context).settingsFilterHighlightLowRtiDesc,
            value: data.highlightLowRti,
            onChanged: onHighlightLowRtiChanged,
          ),
          _ToggleRow(
            icon: Icons.favorite_border,
            label: AppLocalizations.of(context).settingsFilterWishlistAlert,
            description: AppLocalizations.of(context).settingsFilterWishlistAlertDesc,
            value: data.wishlistAlert,
            onChanged: onWishlistAlertChanged,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          _FilterInputLabel(
            label: AppLocalizations.of(context).settingsFilterCategory,
            description: AppLocalizations.of(context).settingsFilterCategoryDesc,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            value: data.categoryFilterId,
            decoration: _inputDecoration(),
            hint: Text(AppLocalizations.of(context).settingsFilterCategoryAll),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(AppLocalizations.of(context).settingsFilterCategoryAll),
              ),
              for (final cat in topCategories)
                DropdownMenuItem<String>(
                  value: cat.id,
                  child: Text(cat.label),
                ),
            ],
            onChanged: (id) {
              final label = id == null
                  ? null
                  : topCategories.firstWhere((c) => c.id == id).label;
              onCategoryChanged(id, label);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _FilterInputLabel(
            label: AppLocalizations.of(context).settingsFilterMinReview,
            description: AppLocalizations.of(context).settingsFilterMinReviewDesc,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: minReviewController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(
                suffixText: AppLocalizations.of(context).settingsFilterMinReviewSuffix,
              ),
              onChanged: onMinReviewCountChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _FilterInputLabel(
            label: AppLocalizations.of(context).settingsFilterLowRti,
            description: AppLocalizations.of(context).settingsFilterLowRtiDesc,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: lowRtiController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(
                suffixText: AppLocalizations.of(context).settingsFilterLowRtiSuffix,
              ),
              onChanged: onLowRtiThresholdChanged,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({String? suffixText}) {
  return InputDecoration(
    suffixText: suffixText,
    isDense: true,
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
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    filled: true,
    fillColor: AppColors.surface,
  );
}

class _FilterInputLabel extends StatelessWidget {
  const _FilterInputLabel({required this.label, required this.description});
  final String label;
  final String description;

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
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Account panel (right column top)
// ─────────────────────────────────────────────────────────────

class _AccountPanel extends StatelessWidget {
  const _AccountPanel({required this.profile, required this.onPasswordTap});
  final UserProfile? profile;
  final VoidCallback onPasswordTap;

  @override
  Widget build(BuildContext context) {
    final createdAt = profile?.createdAt;
    final joinLabel = createdAt != null
        ? '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}'
        : '-';

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                bg: AppColors.primaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).settingsAccountTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onPasswordTap,
                child: Text(
                  AppLocalizations.of(context).settingsAccountChangePassword,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelName,
            value: profile?.nickname.isEmpty ?? true
                ? AppLocalizations.of(context).settingsAccountDefaultName
                : profile!.nickname,
          ),
          _InfoRow(label: AppLocalizations.of(context).settingsAccountLabelEmail, value: profile?.email ?? '-'),
          _InfoRow(label: AppLocalizations.of(context).settingsAccountLabelJoinDate, value: joinLabel),
          _InfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelMemberType,
            value: profile?.role.isEmpty ?? true
                ? AppLocalizations.of(context).settingsAccountMemberLabel('USER')
                : AppLocalizations.of(context).settingsAccountMemberLabel(profile!.role),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).settingsAccountLinkedServices,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _ServiceRow(label: '네이버 쇼핑', connected: true),
          _ServiceRow(label: '쿠팡', connected: true),
          _ServiceRow(label: '11번가', connected: false),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.label, required this.connected});
  final String label;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: connected
                  ? AppColors.successSoft
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              connected
                  ? AppLocalizations.of(context).settingsAccountConnected
                  : AppLocalizations.of(context).settingsAccountDisconnected,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: connected ? AppColors.success : AppColors.textTertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Language section (right column bottom)
// ─────────────────────────────────────────────────────────────

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  static const _langs = [
    (locale: Locale('ko'), label: '한국어', sub: 'Korean'),
    (locale: Locale('en'), label: 'English', sub: 'English'),
    (locale: Locale('ja'), label: '日本語', sub: 'Japanese'),
    (locale: Locale('zh'), label: '中文', sub: 'Chinese'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.language_outlined,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            title: AppLocalizations.of(context).settingsLanguageSection,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context).settingsLanguageApplyNow,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
              mainAxisExtent: 56,
            ),
            itemCount: _langs.length,
            itemBuilder: (context, index) {
              final lang = _langs[index];
              return _LangChip(
                label: lang.label,
                sub: lang.sub,
                selected: currentLocale.languageCode == lang.locale.languageCode,
                onTap: () => onLocaleChanged(lang.locale),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppColors.onPrimary,
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      sub,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? AppColors.onPrimary.withValues(alpha: 0.75)
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Save bar
// ─────────────────────────────────────────────────────────────

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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isSaved
              ? Padding(
                  key: const ValueKey('saved'),
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context).settingsSavedFeedback,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('idle')),
        ),
        FilledButton(
          onPressed: isSaving ? null : onSave,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(100, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
          ),
          child: isSaving
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : Text(AppLocalizations.of(context).actionSave, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBadge(icon: icon, iconColor: iconColor, bg: iconBg),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.iconColor,
    required this.bg,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: AppColors.border, height: 1),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

String _formatPrice(int price) {
  final digits = price.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return '${buf}원';
}
