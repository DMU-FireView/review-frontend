// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => '홈';

  @override
  String get navSearch => '검색';

  @override
  String get navCart => '장바구니';

  @override
  String get navWishlist => '저장한 상품';

  @override
  String get navMyPage => '마이페이지';

  @override
  String get navSettings => '설정';

  @override
  String get actionSave => '저장';

  @override
  String get actionCancel => '취소';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get actionBack => '뒤로';

  @override
  String get actionLogin => '로그인';

  @override
  String get actionLogout => '로그아웃';

  @override
  String get actionSignup => '회원가입';

  @override
  String get actionViewAll => '전체 보기';

  @override
  String get stateLoading => '불러오는 중입니다.';

  @override
  String get stateError => '오류가 발생했습니다.';

  @override
  String get stateEmpty => '표시할 항목이 없습니다.';

  @override
  String get settingsSaved => '설정이 저장되었습니다.';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsNotifications => '알림 설정';

  @override
  String get settingsFilters => '분석 필터 설정';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => '주문/배송';

  @override
  String get sideNavRecentlyViewed => '최근 본 상품';

  @override
  String get sideNavReviewActivity => '리뷰 활동';

  @override
  String get sideNavAccountSettings => '계정 설정';

  @override
  String get sideNavFeedbackHistory => '피드백 내역';

  @override
  String get settingsSubtitle => '알림, 필터, 계정 설정을 관리해요.';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '$nickname님의 알림, 필터, 계정 설정을 관리해요.';
  }

  @override
  String get settingsNotificationEmail => '이메일 알림 받기';

  @override
  String get settingsNotificationEmailDesc => '상품 가격 변동, 리뷰 업데이트를 이메일로 받아요.';

  @override
  String get settingsNotificationPush => '앱 푸시 알림 받기';

  @override
  String get settingsNotificationPushDesc => '저장한 상품의 실시간 알림을 브라우저에서 받아요.';

  @override
  String get settingsNotificationAdEmail => '이메일 광고 수신';

  @override
  String get settingsNotificationAdEmailDesc => '프로모션 및 맞춤 혜택 정보를 이메일로 받아요.';

  @override
  String get settingsFilterHighlightLowRti => '주의 상품 먼저 보기';

  @override
  String get settingsFilterHighlightLowRtiDesc => '리뷰 신뢰도가 낮은 상품을 목록 상단에 표시해요.';

  @override
  String get settingsFilterWishlistAlert => '저장 상품 알림 받기';

  @override
  String get settingsFilterWishlistAlertDesc => '관심 상품의 RTI 변화가 있을 때 알림을 드려요.';

  @override
  String get settingsFilterCategory => '카테고리 필터';

  @override
  String get settingsFilterCategoryDesc => '선택한 카테고리 상품을 기준으로 분석 결과를 우선 표시해요.';

  @override
  String get settingsFilterCategoryAll => '전체 카테고리';

  @override
  String get settingsFilterMinReview => '리뷰 최소 개수';

  @override
  String get settingsFilterMinReviewDesc => '이 개수 이상 리뷰가 있는 상품만 분석 결과에 반영해요.';

  @override
  String get settingsFilterMinReviewSuffix => '개';

  @override
  String get settingsFilterLowRti => '낮은 RTI 경고 기준';

  @override
  String get settingsFilterLowRtiDesc => 'RTI 점수가 이 값 이하면 주의 상품으로 분류해요.';

  @override
  String get settingsFilterLowRtiSuffix => '점';

  @override
  String get settingsAccountTitle => '계정';

  @override
  String get settingsAccountChangePassword => '비밀번호 변경';

  @override
  String get settingsAccountLabelName => '이름';

  @override
  String get settingsAccountLabelEmail => '이메일';

  @override
  String get settingsAccountLabelJoinDate => '가입일';

  @override
  String get settingsAccountLabelMemberType => '회원 유형';

  @override
  String get settingsAccountDefaultName => '사용자';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role 회원';
  }

  @override
  String get settingsAccountLinkedServices => '연동 서비스';

  @override
  String get settingsAccountConnected => '연동됨';

  @override
  String get settingsAccountDisconnected => '미연동';

  @override
  String get settingsLanguageSection => '언어 설정';

  @override
  String get settingsLanguageApplyNow => '변경 즉시 적용됩니다.';

  @override
  String get settingsSavedFeedback => '저장됐어요';

  @override
  String get wishlistTitle => '찜한 상품';

  @override
  String get wishlistSubtitle => '저장된 상품을 한눈에 보고 가격과 리뷰 신뢰도를 확인해보세요.';

  @override
  String wishlistCount(int count) {
    return '찜한 상품 $count개';
  }

  @override
  String get wishlistEmpty => '찜한 상품이 없습니다';

  @override
  String get wishlistEmptyDesc => '상품 카드의 하트를 눌러 찜 목록에 추가해보세요.';

  @override
  String get wishlistBrowse => '상품 탐색하러 가기';

  @override
  String get wishlistFilteredEmpty => '선택한 필터에 해당하는 찜 상품이 없습니다.';

  @override
  String get wishlistSummaryTitle => '찜 리스트 요약';

  @override
  String wishlistSummaryTotal(int count) {
    return '총 $count개';
  }

  @override
  String get wishlistSummaryPriceDrop => '가격 하락';

  @override
  String get wishlistSummaryNewAlert => '신규 알림';

  @override
  String get wishlistSummaryTotalReview => '총 리뷰';

  @override
  String get wishlistProductView => '상품 보기';

  @override
  String get wishlistProductPriceDrop => '가격 하락';

  @override
  String get wishlistSortRecent => '최근 저장 순';

  @override
  String get wishlistSortPriceLow => '낮은 가격 순';

  @override
  String get wishlistSortPriceHigh => '높은 가격 순';

  @override
  String get wishlistSortRti => 'RTI 높은 순';

  @override
  String get wishlistSortReviewCount => '리뷰 많은 순';

  @override
  String get wishlistFilterAll => '전체';

  @override
  String get wishlistFilterPriceDrop => '가격 하락';

  @override
  String get wishlistFilterRti => 'RTI 점수';

  @override
  String get wishlistFilterLowestPrice => '최저 가격';

  @override
  String get wishlistFilterBrand => '브랜드';

  @override
  String get wishlistFilterCategory => '카테고리';

  @override
  String get myPageTitle => '마이페이지';

  @override
  String get myPageLoading => '마이페이지 정보를 불러오는 중입니다.';

  @override
  String get myPageWishlistLoading => '저장한 상품을 불러오는 중입니다.';

  @override
  String get myPageWishlistEmpty => '저장한 상품이 없습니다.';

  @override
  String get myPageInterestProducts => '관심 상품';

  @override
  String get myPageDefaultName => '사용자';

  @override
  String get myPageMemberBasic => '일반 회원 (무료)';

  @override
  String get myPageSideNavMyPage => '마이페이지';

  @override
  String get myPageSideNavOrders => '주문/배송';

  @override
  String get myPageSideNavWishlist => '저장한 상품';

  @override
  String get myPageSideNavRecentlyViewed => '최근 본 상품';

  @override
  String get myPageSideNavRiskyProducts => '주의 상품';

  @override
  String get myPageSideNavAlerts => '알림';

  @override
  String get myPageRecentActivity => '최근 활동';

  @override
  String get myPageRecentActivityEmpty => '최근 활동이 없습니다.';

  @override
  String get myPageRecentLabel => '최근';

  @override
  String get myPageReviewTrustSummary => '리뷰 신뢰 요약';

  @override
  String get myPageAvgRti => '관심 상품 평균 RTI';

  @override
  String get myPageRtiSaveHint => '관심 상품을 저장하면 리뷰 신뢰도 요약이 표시됩니다.';

  @override
  String get myPageRiskyNone => '현재 대시보드에 주의가 필요한 상품이 없습니다.';

  @override
  String myPageRiskyCount(int count) {
    return '주의 상품 $count개를 확인해보세요.';
  }

  @override
  String get myPageHighlightLowRti => '주의 상품 먼저 보기';

  @override
  String get myPageWishlistAlertLabel => '저장 상품 알림 받기';

  @override
  String get myPageAccountInfo => '계정 정보';

  @override
  String get myPageAccountInfoSubtitle => '개인 정보 및 기본 정보를 관리해요.';

  @override
  String myPageAccountNickname(String nickname) {
    return '닉네임: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return '이메일: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return '회원 유형: $role';
  }

  @override
  String get myPageDefaultMemberRole => '일반 회원';

  @override
  String get myPageLoginInfo => '로그인 정보';

  @override
  String get myPageLoginInfoSubtitle => '이메일, 로그인 수단을 관리해요.';

  @override
  String myPageLoginEmail(String email) {
    return '로그인 이메일: $email';
  }

  @override
  String get myPageLoginStatus => '인증 상태: 로그인됨';

  @override
  String get myPageOnboardingComplete => '완료';

  @override
  String get myPageOnboardingIncomplete => '미완료';

  @override
  String myPageOnboarding(String status) {
    return '온보딩: $status';
  }

  @override
  String get myPageChangePassword => '비밀번호 변경';

  @override
  String get myPageChangePasswordSubtitle => '안전한 비밀번호로 관리하세요.';

  @override
  String get myPageNotificationSettings => '알림 설정';

  @override
  String get myPageNotificationSettingsSubtitle => '이메일 및 푸시 알림을 설정해요.';

  @override
  String get myPageAccountSecurity => '계정 / 보안';

  @override
  String get navCategory => '카테고리';

  @override
  String get navWishShort => '찜';

  @override
  String get navMyShort => '마이';

  @override
  String get homeSearchHint => '찾고 있는 상품을 리뷰 기반으로 검색해보세요';

  @override
  String get homeSearchSuggestionsTitle => '연관 검색어';

  @override
  String get homeSearchSuggestionsLoading => '연관 검색어를 불러오는 중입니다.';

  @override
  String get homeSearchSuggestionsHint => '두 글자 이상 입력하면 연관 검색어가 표시됩니다.';

  @override
  String get homeRecentSearchTitle => '최근 검색';

  @override
  String get homeRecentSearchDeleteAll => '전체 삭제';

  @override
  String get homeRecentSearchEmpty => '최근 검색어가 없습니다.';

  @override
  String get homePopularSearchTitle => '인기 검색';

  @override
  String get homeSearchProductsTitle => '추천 상품';

  @override
  String get homeTrendingTitle => '지금 많이 찾는 키워드';

  @override
  String get homeKeywordsEmpty => '표시할 키워드가 없습니다.';

  @override
  String get homeRecommendedTitle => '에디터가 고른 리뷰 기반 추천 상품';

  @override
  String get homeViewAll => '전체보기';

  @override
  String get homeLoginRequired => '로그인이 필요합니다.';

  @override
  String get homeBenefitTitle => '첫 구매 고객을 위한 혜택';

  @override
  String get homeBenefitSubtitle => '리뷰 기반 쇼핑을 시작하면 받을 수 있는 회원 혜택입니다.';

  @override
  String get homeBenefitButton => '혜택 받기';

  @override
  String get homeTrustDescription => '광고·조작 리뷰를 필터링하고 실사용 리뷰를 분석해 신뢰도를 제공합니다.';

  @override
  String get homeTrustViewMore => '자세히 보기';

  @override
  String get homeTrustLabel1 => '실사용 리뷰 분석';

  @override
  String get homeTrustLabel2 => '광고/조작 필터링';

  @override
  String get homeTrustLabel3 => '신뢰도 점수 제공';

  @override
  String get homePopularCategoryTitle => '인기 카테고리';

  @override
  String get homeCategoryEmpty => '표시할 카테고리가 없습니다.';

  @override
  String get feedbackHistoryTitle => '내 피드백 내역';

  @override
  String get feedbackHistorySubtitle => '제출한 상품/리뷰 피드백 내역을 확인할 수 있습니다.';

  @override
  String get feedbackHistoryLoading => '피드백 내역을 불러오는 중입니다.';

  @override
  String get feedbackHistoryEmpty => '제출한 피드백이 없습니다.';

  @override
  String get feedbackHistoryEmptyDesc => '상품 상세 페이지에서 리뷰 피드백을 제출할 수 있습니다.';

  @override
  String feedbackHistoryCount(int count) {
    return '$count건의 피드백';
  }

  @override
  String get feedbackHistoryViewProduct => '상품 보기';

  @override
  String get feedbackStatusSubmitted => '접수';

  @override
  String get feedbackStatusPending => '검토 중';

  @override
  String get feedbackStatusAccepted => '처리됨';

  @override
  String get feedbackStatusRejected => '반려됨';

  @override
  String get adminSidebarTitle => '관리자';

  @override
  String get adminMenuDashboard => '대시보드';

  @override
  String get adminMenuSuspiciousReviews => '의심 리뷰';

  @override
  String get adminMenuReports => '신고 관리';

  @override
  String get adminMenuAnalysisFeedbacks => '분석 피드백';

  @override
  String get adminMenuUsers => '유저';

  @override
  String get adminMenuLogout => '로그아웃';

  @override
  String get adminDashboardTitle => '운영 대시보드';

  @override
  String get adminPlaceholderMessage => '준비 중인 화면입니다.';
}
