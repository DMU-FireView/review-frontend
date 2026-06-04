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
}
