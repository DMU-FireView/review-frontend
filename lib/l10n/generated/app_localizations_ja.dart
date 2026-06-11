// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => 'ホーム';

  @override
  String get navSearch => '検索';

  @override
  String get navCart => 'カート';

  @override
  String get navWishlist => '保存済み';

  @override
  String get navMyPage => 'マイページ';

  @override
  String get navSettings => '設定';

  @override
  String get actionSave => '保存';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionRetry => '再試行';

  @override
  String get actionBack => '戻る';

  @override
  String get actionLogin => 'ログイン';

  @override
  String get actionLogout => 'ログアウト';

  @override
  String get actionSignup => '新規登録';

  @override
  String get actionViewAll => 'すべて見る';

  @override
  String get stateLoading => '読み込み中…';

  @override
  String get stateError => 'エラーが発生しました。';

  @override
  String get stateEmpty => '表示する項目がありません。';

  @override
  String get settingsSaved => '設定を保存しました。';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsNotifications => '通知設定';

  @override
  String get settingsFilters => '分析フィルター設定';

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
  String get sideNavFeedbackHistory => 'フィードバック履歴';

  @override
  String get settingsSubtitle => '通知、フィルター、アカウント設定を管理します。';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '$nicknameさんの通知、フィルター、アカウント設定を管理します。';
  }

  @override
  String get settingsNotificationEmail => 'メール通知を受け取る';

  @override
  String get settingsNotificationEmailDesc => '商品価格の変動、レビュー更新をメールで受け取ります。';

  @override
  String get settingsNotificationPush => 'アプリプッシュ通知を受け取る';

  @override
  String get settingsNotificationPushDesc => '保存した商品のリアルタイム通知をブラウザで受け取ります。';

  @override
  String get settingsNotificationAdEmail => 'メール広告の受信';

  @override
  String get settingsNotificationAdEmailDesc => 'プロモーションやカスタム特典情報をメールで受け取ります。';

  @override
  String get settingsFilterHighlightLowRti => '注意商品を先に表示';

  @override
  String get settingsFilterHighlightLowRtiDesc => 'レビュー信頼度が低い商品をリストの上部に表示します。';

  @override
  String get settingsFilterWishlistAlert => '保存商品の通知を受け取る';

  @override
  String get settingsFilterWishlistAlertDesc => 'お気に入り商品のRTI変化があるときに通知します。';

  @override
  String get settingsFilterCategory => 'カテゴリフィルター';

  @override
  String get settingsFilterCategoryDesc => '選択したカテゴリの商品を基準に分析結果を優先表示します。';

  @override
  String get settingsFilterCategoryAll => '全カテゴリ';

  @override
  String get settingsFilterMinReview => 'レビュー最小件数';

  @override
  String get settingsFilterMinReviewDesc => 'この件数以上のレビューがある商品のみ分析結果に反映します。';

  @override
  String get settingsFilterMinReviewSuffix => '件';

  @override
  String get settingsFilterLowRti => '低RTI警告基準';

  @override
  String get settingsFilterLowRtiDesc => 'RTIスコアがこの値以下の場合、注意商品として分類します。';

  @override
  String get settingsFilterLowRtiSuffix => '点';

  @override
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsAccountChangePassword => 'パスワード変更';

  @override
  String get settingsAccountLabelName => '名前';

  @override
  String get settingsAccountLabelEmail => 'メール';

  @override
  String get settingsAccountLabelJoinDate => '登録日';

  @override
  String get settingsAccountLabelMemberType => '会員種別';

  @override
  String get settingsAccountDefaultName => 'ユーザー';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role会員';
  }

  @override
  String get settingsAccountLinkedServices => '連携サービス';

  @override
  String get settingsAccountConnected => '連携済み';

  @override
  String get settingsAccountDisconnected => '未連携';

  @override
  String get settingsLanguageSection => '言語設定';

  @override
  String get settingsLanguageApplyNow => '変更はすぐに適用されます。';

  @override
  String get settingsSavedFeedback => '保存しました';

  @override
  String get wishlistTitle => 'お気に入り';

  @override
  String get wishlistSubtitle => '保存した商品を一目で確認し、価格とレビュー信頼度をチェックしましょう。';

  @override
  String wishlistCount(int count) {
    return 'お気に入り$count件';
  }

  @override
  String get wishlistEmpty => 'お気に入りはありません';

  @override
  String get wishlistEmptyDesc => '商品カードのハートを押してお気に入りに追加しましょう。';

  @override
  String get wishlistBrowse => '商品を探す';

  @override
  String get wishlistFilteredEmpty => '選択したフィルターに該当するお気に入りはありません。';

  @override
  String get wishlistSummaryTitle => 'お気に入りリスト概要';

  @override
  String wishlistSummaryTotal(int count) {
    return '合計$count件';
  }

  @override
  String get wishlistSummaryPriceDrop => '価格下落';

  @override
  String get wishlistSummaryNewAlert => '新着通知';

  @override
  String get wishlistSummaryTotalReview => '総レビュー';

  @override
  String get wishlistProductView => '商品を見る';

  @override
  String get wishlistProductPriceDrop => '価格下落';

  @override
  String get wishlistSortRecent => '最近保存順';

  @override
  String get wishlistSortPriceLow => '低価格順';

  @override
  String get wishlistSortPriceHigh => '高価格順';

  @override
  String get wishlistSortRti => 'RTI高い順';

  @override
  String get wishlistSortReviewCount => 'レビュー多い順';

  @override
  String get wishlistFilterAll => '全体';

  @override
  String get wishlistFilterPriceDrop => '価格下落';

  @override
  String get wishlistFilterRti => 'RTIスコア';

  @override
  String get wishlistFilterLowestPrice => '最安値';

  @override
  String get wishlistFilterBrand => 'ブランド';

  @override
  String get wishlistFilterCategory => 'カテゴリ';

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
  String get navCategory => 'カテゴリ';

  @override
  String get navWishShort => '保存済み';

  @override
  String get navMyShort => 'マイ';

  @override
  String get homeSearchHint => 'レビューを基準に商品を検索してみましょう';

  @override
  String get homeSearchSuggestionsTitle => '関連検索語';

  @override
  String get homeSearchSuggestionsLoading => '関連検索語を読み込んでいます。';

  @override
  String get homeSearchSuggestionsHint => '2文字以上入力すると関連検索語が表示されます。';

  @override
  String get homeRecentSearchTitle => '最近の検索';

  @override
  String get homeRecentSearchDeleteAll => '全て削除';

  @override
  String get homeRecentSearchEmpty => '最近の検索語がありません。';

  @override
  String get homePopularSearchTitle => '人気検索';

  @override
  String get homeSearchProductsTitle => 'おすすめ商品';

  @override
  String get homeTrendingTitle => '今よく検索されているキーワード';

  @override
  String get homeKeywordsEmpty => '表示するキーワードがありません。';

  @override
  String get homeRecommendedTitle => 'エディターが選んだレビュー基準のおすすめ商品';

  @override
  String get homeViewAll => '全て見る';

  @override
  String get homeLoginRequired => 'ログインが必要です。';

  @override
  String get homeBenefitTitle => '初回購入のお客様へのご特典';

  @override
  String get homeBenefitSubtitle => 'レビュー基準のショッピングを始めると受け取れる会員特典です。';

  @override
  String get homeBenefitButton => '特典を受け取る';

  @override
  String get homeTrustDescription =>
      '広告・操作レビューをフィルタリングし、実使用レビューを分析して信頼度を提供します。';

  @override
  String get homeTrustViewMore => '詳しく見る';

  @override
  String get homeTrustLabel1 => '実使用レビュー分析';

  @override
  String get homeTrustLabel2 => '広告/操作フィルタリング';

  @override
  String get homeTrustLabel3 => '信頼度スコア提供';

  @override
  String get homePopularCategoryTitle => '人気カテゴリ';

  @override
  String get homeCategoryEmpty => '表示するカテゴリがありません。';

  @override
  String get feedbackHistoryTitle => 'フィードバック履歴';

  @override
  String get feedbackHistorySubtitle => '投稿した商品・レビューのフィードバック履歴を確認できます。';

  @override
  String get feedbackHistoryLoading => 'フィードバック履歴を読み込んでいます。';

  @override
  String get feedbackHistoryEmpty => '投稿したフィードバックがありません。';

  @override
  String get feedbackHistoryEmptyDesc => '商品詳細ページでレビューフィードバックを投稿できます。';

  @override
  String feedbackHistoryCount(int count) {
    return '$count件のフィードバック';
  }

  @override
  String get feedbackHistoryViewProduct => '商品を見る';

  @override
  String get feedbackStatusSubmitted => '受付';

  @override
  String get feedbackStatusPending => '審査中';

  @override
  String get feedbackStatusAccepted => '処理済み';

  @override
  String get feedbackStatusRejected => '却下';
}
