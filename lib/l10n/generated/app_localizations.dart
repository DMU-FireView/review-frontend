import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'Re:view'**
  String get appTitle;

  /// 홈 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// 검색 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get navSearch;

  /// 장바구니 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'장바구니'**
  String get navCart;

  /// 위시리스트 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품'**
  String get navWishlist;

  /// 마이페이지 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get navMyPage;

  /// 설정 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get navSettings;

  /// 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get actionSave;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get actionCancel;

  /// 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get actionConfirm;

  /// 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get actionRetry;

  /// 뒤로가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get actionBack;

  /// 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get actionLogin;

  /// 로그아웃 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get actionLogout;

  /// 회원가입 버튼
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get actionSignup;

  /// 전체 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get actionViewAll;

  /// 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중입니다.'**
  String get stateLoading;

  /// 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다.'**
  String get stateError;

  /// 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 항목이 없습니다.'**
  String get stateEmpty;

  /// 설정 저장 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'설정이 저장되었습니다.'**
  String get settingsSaved;

  /// 언어 설정 레이블
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settingsNotifications;

  /// 분석 필터 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'분석 필터 설정'**
  String get settingsFilters;

  /// 언어명 한국어
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get langKorean;

  /// 언어명 영어
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// 언어명 일본어
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get langJapanese;

  /// 언어명 중국어 간체
  ///
  /// In ko, this message translates to:
  /// **'中文(简体)'**
  String get langChinese;

  /// 사이드 네비게이션 주문/배송
  ///
  /// In ko, this message translates to:
  /// **'주문/배송'**
  String get sideNavOrders;

  /// 사이드 네비게이션 최근 본 상품
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품'**
  String get sideNavRecentlyViewed;

  /// 사이드 네비게이션 리뷰 활동
  ///
  /// In ko, this message translates to:
  /// **'리뷰 활동'**
  String get sideNavReviewActivity;

  /// 사이드 네비게이션 계정 설정
  ///
  /// In ko, this message translates to:
  /// **'계정 설정'**
  String get sideNavAccountSettings;

  /// 사이드 네비게이션 피드백 내역
  ///
  /// In ko, this message translates to:
  /// **'피드백 내역'**
  String get sideNavFeedbackHistory;

  /// 설정 페이지 부제목 (비로그인)
  ///
  /// In ko, this message translates to:
  /// **'알림, 필터, 계정 설정을 관리해요.'**
  String get settingsSubtitle;

  /// 설정 페이지 부제목 (로그인)
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님의 알림, 필터, 계정 설정을 관리해요.'**
  String settingsSubtitleNamed(String nickname);

  /// 이메일 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일 알림 받기'**
  String get settingsNotificationEmail;

  /// 이메일 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'상품 가격 변동, 리뷰 업데이트를 이메일로 받아요.'**
  String get settingsNotificationEmailDesc;

  /// 푸시 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'앱 푸시 알림 받기'**
  String get settingsNotificationPush;

  /// 푸시 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품의 실시간 알림을 브라우저에서 받아요.'**
  String get settingsNotificationPushDesc;

  /// 광고 이메일 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일 광고 수신'**
  String get settingsNotificationAdEmail;

  /// 광고 이메일 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'프로모션 및 맞춤 혜택 정보를 이메일로 받아요.'**
  String get settingsNotificationAdEmailDesc;

  /// 주의 상품 강조 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 먼저 보기'**
  String get settingsFilterHighlightLowRti;

  /// 주의 상품 강조 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도가 낮은 상품을 목록 상단에 표시해요.'**
  String get settingsFilterHighlightLowRtiDesc;

  /// 저장 상품 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림 받기'**
  String get settingsFilterWishlistAlert;

  /// 저장 상품 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'관심 상품의 RTI 변화가 있을 때 알림을 드려요.'**
  String get settingsFilterWishlistAlertDesc;

  /// 카테고리 필터 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리 필터'**
  String get settingsFilterCategory;

  /// 카테고리 필터 설명
  ///
  /// In ko, this message translates to:
  /// **'선택한 카테고리 상품을 기준으로 분석 결과를 우선 표시해요.'**
  String get settingsFilterCategoryDesc;

  /// 카테고리 전체 선택 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체 카테고리'**
  String get settingsFilterCategoryAll;

  /// 최소 리뷰 개수 필터 레이블
  ///
  /// In ko, this message translates to:
  /// **'리뷰 최소 개수'**
  String get settingsFilterMinReview;

  /// 최소 리뷰 개수 필터 설명
  ///
  /// In ko, this message translates to:
  /// **'이 개수 이상 리뷰가 있는 상품만 분석 결과에 반영해요.'**
  String get settingsFilterMinReviewDesc;

  /// 리뷰 개수 단위
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get settingsFilterMinReviewSuffix;

  /// 낮은 RTI 경고 기준 레이블
  ///
  /// In ko, this message translates to:
  /// **'낮은 RTI 경고 기준'**
  String get settingsFilterLowRti;

  /// 낮은 RTI 경고 기준 설명
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수가 이 값 이하면 주의 상품으로 분류해요.'**
  String get settingsFilterLowRtiDesc;

  /// RTI 점수 단위
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get settingsFilterLowRtiSuffix;

  /// 계정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get settingsAccountTitle;

  /// 비밀번호 변경 링크
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get settingsAccountChangePassword;

  /// 계정 이름 레이블
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get settingsAccountLabelName;

  /// 계정 이메일 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get settingsAccountLabelEmail;

  /// 계정 가입일 레이블
  ///
  /// In ko, this message translates to:
  /// **'가입일'**
  String get settingsAccountLabelJoinDate;

  /// 회원 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'회원 유형'**
  String get settingsAccountLabelMemberType;

  /// 닉네임 미설정 시 기본 이름
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get settingsAccountDefaultName;

  /// 회원 유형 표시 (역할 포함)
  ///
  /// In ko, this message translates to:
  /// **'{role} 회원'**
  String settingsAccountMemberLabel(String role);

  /// 연동 서비스 섹션 레이블
  ///
  /// In ko, this message translates to:
  /// **'연동 서비스'**
  String get settingsAccountLinkedServices;

  /// 서비스 연동 상태
  ///
  /// In ko, this message translates to:
  /// **'연동됨'**
  String get settingsAccountConnected;

  /// 서비스 미연동 상태
  ///
  /// In ko, this message translates to:
  /// **'미연동'**
  String get settingsAccountDisconnected;

  /// 언어 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get settingsLanguageSection;

  /// 언어 변경 즉시 적용 안내
  ///
  /// In ko, this message translates to:
  /// **'변경 즉시 적용됩니다.'**
  String get settingsLanguageApplyNow;

  /// 설정 저장 완료 피드백 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장됐어요'**
  String get settingsSavedFeedback;

  /// 위시리스트 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품'**
  String get wishlistTitle;

  /// 위시리스트 페이지 부제목
  ///
  /// In ko, this message translates to:
  /// **'저장된 상품을 한눈에 보고 가격과 리뷰 신뢰도를 확인해보세요.'**
  String get wishlistSubtitle;

  /// 찜한 상품 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품 {count}개'**
  String wishlistCount(int count);

  /// 위시리스트 빈 상태 제목
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품이 없습니다'**
  String get wishlistEmpty;

  /// 위시리스트 빈 상태 설명
  ///
  /// In ko, this message translates to:
  /// **'상품 카드의 하트를 눌러 찜 목록에 추가해보세요.'**
  String get wishlistEmptyDesc;

  /// 위시리스트 빈 상태 탐색 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 탐색하러 가기'**
  String get wishlistBrowse;

  /// 필터 결과 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'선택한 필터에 해당하는 찜 상품이 없습니다.'**
  String get wishlistFilteredEmpty;

  /// 위시리스트 요약 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'찜 리스트 요약'**
  String get wishlistSummaryTitle;

  /// 위시리스트 총 개수
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개'**
  String wishlistSummaryTotal(int count);

  /// 가격 하락 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistSummaryPriceDrop;

  /// 신규 알림 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'신규 알림'**
  String get wishlistSummaryNewAlert;

  /// 총 리뷰 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 리뷰'**
  String get wishlistSummaryTotalReview;

  /// 위시리스트 상품 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 보기'**
  String get wishlistProductView;

  /// 상품 카드 가격 하락 뱃지
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistProductPriceDrop;

  /// 최근 저장 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'최근 저장 순'**
  String get wishlistSortRecent;

  /// 낮은 가격 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'낮은 가격 순'**
  String get wishlistSortPriceLow;

  /// 높은 가격 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'높은 가격 순'**
  String get wishlistSortPriceHigh;

  /// RTI 높은 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'RTI 높은 순'**
  String get wishlistSortRti;

  /// 리뷰 많은 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'리뷰 많은 순'**
  String get wishlistSortReviewCount;

  /// 전체 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get wishlistFilterAll;

  /// 가격 하락 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistFilterPriceDrop;

  /// RTI 점수 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수'**
  String get wishlistFilterRti;

  /// 최저 가격 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'최저 가격'**
  String get wishlistFilterLowestPrice;

  /// 브랜드 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'브랜드'**
  String get wishlistFilterBrand;

  /// 카테고리 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get wishlistFilterCategory;

  /// 마이페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageTitle;

  /// 마이페이지 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'마이페이지 정보를 불러오는 중입니다.'**
  String get myPageLoading;

  /// 위시리스트 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품을 불러오는 중입니다.'**
  String get myPageWishlistLoading;

  /// 위시리스트 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품이 없습니다.'**
  String get myPageWishlistEmpty;

  /// 관심 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'관심 상품'**
  String get myPageInterestProducts;

  /// 닉네임 미설정 시 기본 이름
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get myPageDefaultName;

  /// 일반 회원 표시 문구
  ///
  /// In ko, this message translates to:
  /// **'일반 회원 (무료)'**
  String get myPageMemberBasic;

  /// 사이드 네비게이션 마이페이지
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageSideNavMyPage;

  /// 사이드 네비게이션 주문/배송
  ///
  /// In ko, this message translates to:
  /// **'주문/배송'**
  String get myPageSideNavOrders;

  /// 사이드 네비게이션 저장한 상품
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품'**
  String get myPageSideNavWishlist;

  /// 사이드 네비게이션 최근 본 상품
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품'**
  String get myPageSideNavRecentlyViewed;

  /// 사이드 네비게이션 주의 상품
  ///
  /// In ko, this message translates to:
  /// **'주의 상품'**
  String get myPageSideNavRiskyProducts;

  /// 사이드 네비게이션 알림
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get myPageSideNavAlerts;

  /// 최근 활동 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 활동'**
  String get myPageRecentActivity;

  /// 최근 활동 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'최근 활동이 없습니다.'**
  String get myPageRecentActivityEmpty;

  /// 최근 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'최근'**
  String get myPageRecentLabel;

  /// 리뷰 신뢰 요약 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰 요약'**
  String get myPageReviewTrustSummary;

  /// 관심 상품 평균 RTI 레이블
  ///
  /// In ko, this message translates to:
  /// **'관심 상품 평균 RTI'**
  String get myPageAvgRti;

  /// RTI 요약 저장 안내
  ///
  /// In ko, this message translates to:
  /// **'관심 상품을 저장하면 리뷰 신뢰도 요약이 표시됩니다.'**
  String get myPageRtiSaveHint;

  /// 주의 상품 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'현재 대시보드에 주의가 필요한 상품이 없습니다.'**
  String get myPageRiskyNone;

  /// 주의 상품 개수 안내
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 {count}개를 확인해보세요.'**
  String myPageRiskyCount(int count);

  /// 주의 상품 먼저 보기 레이블
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 먼저 보기'**
  String get myPageHighlightLowRti;

  /// 저장 상품 알림 레이블
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림 받기'**
  String get myPageWishlistAlertLabel;

  /// 계정 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get myPageAccountInfo;

  /// 계정 정보 섹션 부제목
  ///
  /// In ko, this message translates to:
  /// **'개인 정보 및 기본 정보를 관리해요.'**
  String get myPageAccountInfoSubtitle;

  /// 닉네임 표시
  ///
  /// In ko, this message translates to:
  /// **'닉네임: {nickname}'**
  String myPageAccountNickname(String nickname);

  /// 이메일 표시
  ///
  /// In ko, this message translates to:
  /// **'이메일: {email}'**
  String myPageAccountEmail(String email);

  /// 회원 유형 표시
  ///
  /// In ko, this message translates to:
  /// **'회원 유형: {role}'**
  String myPageAccountMemberType(String role);

  /// 기본 회원 유형
  ///
  /// In ko, this message translates to:
  /// **'일반 회원'**
  String get myPageDefaultMemberRole;

  /// 로그인 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'로그인 정보'**
  String get myPageLoginInfo;

  /// 로그인 정보 섹션 부제목
  ///
  /// In ko, this message translates to:
  /// **'이메일, 로그인 수단을 관리해요.'**
  String get myPageLoginInfoSubtitle;

  /// 로그인 이메일 표시
  ///
  /// In ko, this message translates to:
  /// **'로그인 이메일: {email}'**
  String myPageLoginEmail(String email);

  /// 로그인 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'인증 상태: 로그인됨'**
  String get myPageLoginStatus;

  /// 온보딩 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get myPageOnboardingComplete;

  /// 온보딩 미완료 상태
  ///
  /// In ko, this message translates to:
  /// **'미완료'**
  String get myPageOnboardingIncomplete;

  /// 온보딩 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'온보딩: {status}'**
  String myPageOnboarding(String status);

  /// 비밀번호 변경 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get myPageChangePassword;

  /// 비밀번호 변경 부제목
  ///
  /// In ko, this message translates to:
  /// **'안전한 비밀번호로 관리하세요.'**
  String get myPageChangePasswordSubtitle;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get myPageNotificationSettings;

  /// 알림 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'이메일 및 푸시 알림을 설정해요.'**
  String get myPageNotificationSettingsSubtitle;

  /// 계정/보안 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'계정 / 보안'**
  String get myPageAccountSecurity;

  /// 모바일 하단 네비게이션 카테고리
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get navCategory;

  /// 모바일 하단 네비게이션 찜 (짧은 표현)
  ///
  /// In ko, this message translates to:
  /// **'찜'**
  String get navWishShort;

  /// 모바일 하단 네비게이션 마이페이지 (짧은 표현)
  ///
  /// In ko, this message translates to:
  /// **'마이'**
  String get navMyShort;

  /// 홈 검색바 힌트 텍스트
  ///
  /// In ko, this message translates to:
  /// **'찾고 있는 상품을 리뷰 기반으로 검색해보세요'**
  String get homeSearchHint;

  /// 검색 패널 연관 검색어 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어'**
  String get homeSearchSuggestionsTitle;

  /// 연관 검색어 로딩 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어를 불러오는 중입니다.'**
  String get homeSearchSuggestionsLoading;

  /// 연관 검색어 입력 유도 메시지
  ///
  /// In ko, this message translates to:
  /// **'두 글자 이상 입력하면 연관 검색어가 표시됩니다.'**
  String get homeSearchSuggestionsHint;

  /// 최근 검색 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 검색'**
  String get homeRecentSearchTitle;

  /// 최근 검색어 전체 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get homeRecentSearchDeleteAll;

  /// 최근 검색어 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어가 없습니다.'**
  String get homeRecentSearchEmpty;

  /// 인기 검색 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'인기 검색'**
  String get homePopularSearchTitle;

  /// 검색 패널 추천 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'추천 상품'**
  String get homeSearchProductsTitle;

  /// 트렌딩 키워드 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'지금 많이 찾는 키워드'**
  String get homeTrendingTitle;

  /// 트렌딩 키워드 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 키워드가 없습니다.'**
  String get homeKeywordsEmpty;

  /// 추천 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'에디터가 고른 리뷰 기반 추천 상품'**
  String get homeRecommendedTitle;

  /// 전체보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get homeViewAll;

  /// 로그인 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다.'**
  String get homeLoginRequired;

  /// 혜택 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'첫 구매 고객을 위한 혜택'**
  String get homeBenefitTitle;

  /// 혜택 카드 부제목
  ///
  /// In ko, this message translates to:
  /// **'리뷰 기반 쇼핑을 시작하면 받을 수 있는 회원 혜택입니다.'**
  String get homeBenefitSubtitle;

  /// 혜택 받기 버튼
  ///
  /// In ko, this message translates to:
  /// **'혜택 받기'**
  String get homeBenefitButton;

  /// 리뷰 신뢰도 설명
  ///
  /// In ko, this message translates to:
  /// **'광고·조작 리뷰를 필터링하고 실사용 리뷰를 분석해 신뢰도를 제공합니다.'**
  String get homeTrustDescription;

  /// 자세히 보기 링크
  ///
  /// In ko, this message translates to:
  /// **'자세히 보기'**
  String get homeTrustViewMore;

  /// 신뢰도 기능 레이블 1
  ///
  /// In ko, this message translates to:
  /// **'실사용 리뷰 분석'**
  String get homeTrustLabel1;

  /// 신뢰도 기능 레이블 2
  ///
  /// In ko, this message translates to:
  /// **'광고/조작 필터링'**
  String get homeTrustLabel2;

  /// 신뢰도 기능 레이블 3
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 점수 제공'**
  String get homeTrustLabel3;

  /// 인기 카테고리 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'인기 카테고리'**
  String get homePopularCategoryTitle;

  /// 카테고리 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 카테고리가 없습니다.'**
  String get homeCategoryEmpty;

  /// 피드백 내역 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'내 피드백 내역'**
  String get feedbackHistoryTitle;

  /// 피드백 내역 페이지 부제목
  ///
  /// In ko, this message translates to:
  /// **'제출한 상품/리뷰 피드백 내역을 확인할 수 있습니다.'**
  String get feedbackHistorySubtitle;

  /// 피드백 내역 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'피드백 내역을 불러오는 중입니다.'**
  String get feedbackHistoryLoading;

  /// 피드백 내역 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'제출한 피드백이 없습니다.'**
  String get feedbackHistoryEmpty;

  /// 피드백 내역 없을 때 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'상품 상세 페이지에서 리뷰 피드백을 제출할 수 있습니다.'**
  String get feedbackHistoryEmptyDesc;

  /// 피드백 건수
  ///
  /// In ko, this message translates to:
  /// **'{count}건의 피드백'**
  String feedbackHistoryCount(int count);

  /// 피드백 카드 상품 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 보기'**
  String get feedbackHistoryViewProduct;

  /// No description provided for @feedbackStatusSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'접수'**
  String get feedbackStatusSubmitted;

  /// 피드백 상태: 검토 중
  ///
  /// In ko, this message translates to:
  /// **'검토 중'**
  String get feedbackStatusPending;

  /// 피드백 상태: 처리됨
  ///
  /// In ko, this message translates to:
  /// **'처리됨'**
  String get feedbackStatusAccepted;

  /// 피드백 상태: 반려됨
  ///
  /// In ko, this message translates to:
  /// **'반려됨'**
  String get feedbackStatusRejected;

  /// 관리자 사이드바 타이틀
  ///
  /// In ko, this message translates to:
  /// **'관리자'**
  String get adminSidebarTitle;

  /// 관리자 메뉴 — 대시보드
  ///
  /// In ko, this message translates to:
  /// **'대시보드'**
  String get adminMenuDashboard;

  /// 관리자 메뉴 — 의심 리뷰 관리
  ///
  /// In ko, this message translates to:
  /// **'의심 리뷰 관리'**
  String get adminMenuSuspiciousReviews;

  /// 관리자 메뉴 — 신고 관리
  ///
  /// In ko, this message translates to:
  /// **'신고 관리'**
  String get adminMenuReports;

  /// 관리자 메뉴 — 분석 피드백 관리
  ///
  /// In ko, this message translates to:
  /// **'분석 피드백 관리'**
  String get adminMenuAnalysisFeedbacks;

  /// 관리자 메뉴 — 사용자 관리
  ///
  /// In ko, this message translates to:
  /// **'사용자 관리'**
  String get adminMenuUsers;

  /// 관리자 사이드바 로그아웃 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get adminMenuLogout;

  /// 관리자 대시보드 페이지 타이틀
  ///
  /// In ko, this message translates to:
  /// **'운영 대시보드'**
  String get adminDashboardTitle;

  /// 구현 대기 중인 관리자 페이지 안내
  ///
  /// In ko, this message translates to:
  /// **'준비 중인 화면입니다.'**
  String get adminPlaceholderMessage;

  /// 관리자 상단 검색바 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'사용자, 리뷰, 신고 ID로 검색'**
  String get adminTopBarSearchHint;

  /// 관리자 상단 알림 벨 툴팁
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get adminTopBarNotifications;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
