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
