// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navCart => 'Cart';

  @override
  String get navWishlist => 'Saved';

  @override
  String get navMyPage => 'My Page';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionBack => 'Back';

  @override
  String get actionLogin => 'Log in';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionSignup => 'Sign up';

  @override
  String get actionViewAll => 'View all';

  @override
  String get stateLoading => 'Loading…';

  @override
  String get stateError => 'Something went wrong.';

  @override
  String get stateEmpty => 'Nothing to show.';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsFilters => 'Analysis Filters';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => 'Orders';

  @override
  String get sideNavRecentlyViewed => 'Recently Viewed';

  @override
  String get sideNavReviewActivity => 'Review Activity';

  @override
  String get sideNavAccountSettings => 'Account Settings';

  @override
  String get sideNavFeedbackHistory => 'Feedback History';

  @override
  String get settingsSubtitle =>
      'Manage your notifications, filters, and account.';

  @override
  String settingsSubtitleNamed(String nickname) {
    return 'Manage $nickname\'s notifications, filters, and account.';
  }

  @override
  String get settingsNotificationEmail => 'Email Notifications';

  @override
  String get settingsNotificationEmailDesc =>
      'Receive price drops and review updates via email.';

  @override
  String get settingsNotificationPush => 'Push Notifications';

  @override
  String get settingsNotificationPushDesc =>
      'Get real-time alerts for saved products in your browser.';

  @override
  String get settingsNotificationAdEmail => 'Promotional Emails';

  @override
  String get settingsNotificationAdEmailDesc =>
      'Receive promotions and personalized deals via email.';

  @override
  String get settingsFilterHighlightLowRti => 'Show Risky Products First';

  @override
  String get settingsFilterHighlightLowRtiDesc =>
      'Show products with low review trust scores at the top of the list.';

  @override
  String get settingsFilterWishlistAlert => 'Wishlist RTI Alerts';

  @override
  String get settingsFilterWishlistAlertDesc =>
      'Get notified when your saved products\' RTI changes.';

  @override
  String get settingsFilterCategory => 'Category Filter';

  @override
  String get settingsFilterCategoryDesc =>
      'Prioritize analysis results based on the selected category.';

  @override
  String get settingsFilterCategoryAll => 'All Categories';

  @override
  String get settingsFilterMinReview => 'Minimum Review Count';

  @override
  String get settingsFilterMinReviewDesc =>
      'Only include products with at least this many reviews in analysis.';

  @override
  String get settingsFilterMinReviewSuffix => '';

  @override
  String get settingsFilterLowRti => 'Low RTI Warning Threshold';

  @override
  String get settingsFilterLowRtiDesc =>
      'Products with RTI scores at or below this value are flagged.';

  @override
  String get settingsFilterLowRtiSuffix => '';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountChangePassword => 'Change Password';

  @override
  String get settingsAccountLabelName => 'Name';

  @override
  String get settingsAccountLabelEmail => 'Email';

  @override
  String get settingsAccountLabelJoinDate => 'Joined';

  @override
  String get settingsAccountLabelMemberType => 'Member Type';

  @override
  String get settingsAccountDefaultName => 'User';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role Member';
  }

  @override
  String get settingsAccountLinkedServices => 'Connected Services';

  @override
  String get settingsAccountConnected => 'Connected';

  @override
  String get settingsAccountDisconnected => 'Not connected';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageApplyNow => 'Changes apply immediately.';

  @override
  String get settingsSavedFeedback => 'Saved!';

  @override
  String get wishlistTitle => 'Saved Products';

  @override
  String get wishlistSubtitle =>
      'View saved products and check prices and review trust scores at a glance.';

  @override
  String wishlistCount(int count) {
    return '$count saved';
  }

  @override
  String get wishlistEmpty => 'No saved products';

  @override
  String get wishlistEmptyDesc =>
      'Tap the heart on a product card to add it to your list.';

  @override
  String get wishlistBrowse => 'Browse Products';

  @override
  String get wishlistFilteredEmpty =>
      'No saved products match the selected filter.';

  @override
  String get wishlistSummaryTitle => 'Wishlist Summary';

  @override
  String wishlistSummaryTotal(int count) {
    return 'Total $count';
  }

  @override
  String get wishlistSummaryPriceDrop => 'Price Drop';

  @override
  String get wishlistSummaryNewAlert => 'New Alert';

  @override
  String get wishlistSummaryTotalReview => 'Total Reviews';

  @override
  String get wishlistProductView => 'View Product';

  @override
  String get wishlistProductPriceDrop => 'Price Drop';

  @override
  String get wishlistSortRecent => 'Recently Saved';

  @override
  String get wishlistSortPriceLow => 'Price: Low to High';

  @override
  String get wishlistSortPriceHigh => 'Price: High to Low';

  @override
  String get wishlistSortRti => 'RTI: High to Low';

  @override
  String get wishlistSortReviewCount => 'Most Reviews';

  @override
  String get wishlistFilterAll => 'All';

  @override
  String get wishlistFilterPriceDrop => 'Price Drop';

  @override
  String get wishlistFilterRti => 'RTI Score';

  @override
  String get wishlistFilterLowestPrice => 'Lowest Price';

  @override
  String get wishlistFilterBrand => 'Brand';

  @override
  String get wishlistFilterCategory => 'Category';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get myPageLoading => 'Loading your page…';

  @override
  String get myPageWishlistLoading => 'Loading saved products…';

  @override
  String get myPageWishlistEmpty => 'No saved products.';

  @override
  String get myPageInterestProducts => 'Saved Products';

  @override
  String get myPageDefaultName => 'User';

  @override
  String get myPageMemberBasic => 'Basic (Free)';

  @override
  String get myPageSideNavMyPage => 'My Page';

  @override
  String get myPageSideNavOrders => 'Orders';

  @override
  String get myPageSideNavWishlist => 'Saved';

  @override
  String get myPageSideNavRecentlyViewed => 'Recently Viewed';

  @override
  String get myPageSideNavRiskyProducts => 'Risky Products';

  @override
  String get myPageSideNavAlerts => 'Alerts';

  @override
  String get myPageRecentActivity => 'Recent Activity';

  @override
  String get myPageRecentActivityEmpty => 'No recent activity.';

  @override
  String get myPageRecentLabel => 'Recent';

  @override
  String get myPageReviewTrustSummary => 'Review Trust Summary';

  @override
  String get myPageAvgRti => 'Avg. RTI of Saved Products';

  @override
  String get myPageRtiSaveHint =>
      'Save products to see the review trust summary.';

  @override
  String get myPageRiskyNone => 'No products need attention in your dashboard.';

  @override
  String myPageRiskyCount(int count) {
    return 'Check $count risky products.';
  }

  @override
  String get myPageHighlightLowRti => 'Show Risky Products First';

  @override
  String get myPageWishlistAlertLabel => 'Wishlist RTI Alerts';

  @override
  String get myPageAccountInfo => 'Account Info';

  @override
  String get myPageAccountInfoSubtitle =>
      'Manage your personal and basic information.';

  @override
  String myPageAccountNickname(String nickname) {
    return 'Nickname: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return 'Email: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return 'Member Type: $role';
  }

  @override
  String get myPageDefaultMemberRole => 'Basic';

  @override
  String get myPageLoginInfo => 'Login Info';

  @override
  String get myPageLoginInfoSubtitle => 'Manage your email and login method.';

  @override
  String myPageLoginEmail(String email) {
    return 'Login email: $email';
  }

  @override
  String get myPageLoginStatus => 'Auth status: Logged in';

  @override
  String get myPageOnboardingComplete => 'Complete';

  @override
  String get myPageOnboardingIncomplete => 'Incomplete';

  @override
  String myPageOnboarding(String status) {
    return 'Onboarding: $status';
  }

  @override
  String get myPageChangePassword => 'Change Password';

  @override
  String get myPageChangePasswordSubtitle => 'Keep your account secure.';

  @override
  String get myPageNotificationSettings => 'Notifications';

  @override
  String get myPageNotificationSettingsSubtitle =>
      'Set up email and push notifications.';

  @override
  String get myPageAccountSecurity => 'Account / Security';

  @override
  String get navCategory => 'Category';

  @override
  String get navWishShort => 'Saved';

  @override
  String get navMyShort => 'My';

  @override
  String get homeSearchHint => 'Search products based on reviews';

  @override
  String get homeSearchSuggestionsTitle => 'Related Searches';

  @override
  String get homeSearchSuggestionsLoading => 'Loading related searches...';

  @override
  String get homeSearchSuggestionsHint =>
      'Type at least 2 characters to see related searches.';

  @override
  String get homeRecentSearchTitle => 'Recent Searches';

  @override
  String get homeRecentSearchDeleteAll => 'Clear All';

  @override
  String get homeRecentSearchEmpty => 'No recent searches.';

  @override
  String get homePopularSearchTitle => 'Popular';

  @override
  String get homeSearchProductsTitle => 'Suggested Products';

  @override
  String get homeTrendingTitle => 'Trending Keywords';

  @override
  String get homeKeywordsEmpty => 'No keywords to display.';

  @override
  String get homeRecommendedTitle => 'Editor\'s Review-Based Picks';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeLoginRequired => 'Login required.';

  @override
  String get homeBenefitTitle => 'Benefits for New Customers';

  @override
  String get homeBenefitSubtitle =>
      'Enjoy member benefits when you start review-based shopping.';

  @override
  String get homeBenefitButton => 'Get Benefits';

  @override
  String get homeTrustDescription =>
      'We filter promotional and manipulated reviews, analyze genuine reviews, and provide a trust score.';

  @override
  String get homeTrustViewMore => 'Learn More';

  @override
  String get homeTrustLabel1 => 'Real Review Analysis';

  @override
  String get homeTrustLabel2 => 'Ad/Manipulation Filtering';

  @override
  String get homeTrustLabel3 => 'Trust Score';

  @override
  String get homePopularCategoryTitle => 'Popular Categories';

  @override
  String get homeCategoryEmpty => 'No categories to display.';

  @override
  String get feedbackHistoryTitle => 'My Feedback History';

  @override
  String get feedbackHistorySubtitle =>
      'View the history of product/review feedback you\'ve submitted.';

  @override
  String get feedbackHistoryLoading => 'Loading feedback history...';

  @override
  String get feedbackHistoryEmpty => 'No feedback submitted yet.';

  @override
  String get feedbackHistoryEmptyDesc =>
      'You can submit review feedback on the product detail page.';

  @override
  String feedbackHistoryCount(int count) {
    return '$count feedback item(s)';
  }

  @override
  String get feedbackHistoryViewProduct => 'View Product';

  @override
  String get feedbackStatusSubmitted => 'Submitted';

  @override
  String get feedbackStatusPending => 'Under Review';

  @override
  String get feedbackStatusAccepted => 'Accepted';

  @override
  String get feedbackStatusRejected => 'Rejected';

  @override
  String get adminSidebarTitle => 'Admin';

  @override
  String get adminMenuDashboard => 'Dashboard';

  @override
  String get adminMenuSuspiciousReviews => 'Suspicious Reviews';

  @override
  String get adminMenuReports => 'Reports';

  @override
  String get adminMenuAnalysisFeedbacks => 'Analysis Feedback';

  @override
  String get adminMenuUsers => 'Users';

  @override
  String get adminMenuLogout => 'Log out';

  @override
  String get adminDashboardTitle => 'Operations Dashboard';

  @override
  String get adminPlaceholderMessage => 'This screen is coming soon.';
}
