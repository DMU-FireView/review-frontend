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
  String get sideNavOrders => '注文/配送';

  @override
  String get sideNavRecentlyViewed => '最近見た商品';

  @override
  String get sideNavReviewActivity => 'レビュー活動';

  @override
  String get sideNavAccountSettings => 'アカウント設定';

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
  String get myPageTitle => 'マイページ';

  @override
  String get myPageLoading => 'マイページ情報を読み込み中です。';

  @override
  String get myPageWishlistLoading => '保存した商品を読み込み中です。';

  @override
  String get myPageWishlistEmpty => '保存した商品はありません。';

  @override
  String get myPageInterestProducts => 'お気に入り商品';

  @override
  String get myPageDefaultName => 'ユーザー';

  @override
  String get myPageMemberBasic => '一般会員（無料）';

  @override
  String get myPageSideNavMyPage => 'マイページ';

  @override
  String get myPageSideNavOrders => '注文/配送';

  @override
  String get myPageSideNavWishlist => '保存した商品';

  @override
  String get myPageSideNavRecentlyViewed => '最近見た商品';

  @override
  String get myPageSideNavRiskyProducts => '注意商品';

  @override
  String get myPageSideNavAlerts => '通知';

  @override
  String get myPageRecentActivity => '最近の活動';

  @override
  String get myPageRecentActivityEmpty => '最近の活動はありません。';

  @override
  String get myPageRecentLabel => '最近';

  @override
  String get myPageReviewTrustSummary => 'レビュー信頼サマリー';

  @override
  String get myPageAvgRti => 'お気に入り商品の平均RTI';

  @override
  String get myPageRtiSaveHint => 'お気に入りを保存するとレビュー信頼度サマリーが表示されます。';

  @override
  String get myPageRiskyNone => '現在ダッシュボードに注意が必要な商品はありません。';

  @override
  String myPageRiskyCount(int count) {
    return '注意商品$count件を確認してください。';
  }

  @override
  String get myPageHighlightLowRti => '注意商品を先に表示';

  @override
  String get myPageWishlistAlertLabel => '保存商品の通知を受け取る';

  @override
  String get myPageAccountInfo => 'アカウント情報';

  @override
  String get myPageAccountInfoSubtitle => '個人情報および基本情報を管理します。';

  @override
  String myPageAccountNickname(String nickname) {
    return 'ニックネーム: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return 'メール: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return '会員種別: $role';
  }

  @override
  String get myPageDefaultMemberRole => '一般会員';

  @override
  String get myPageLoginInfo => 'ログイン情報';

  @override
  String get myPageLoginInfoSubtitle => 'メール、ログイン手段を管理します。';

  @override
  String myPageLoginEmail(String email) {
    return 'ログインメール: $email';
  }

  @override
  String get myPageLoginStatus => '認証状態: ログイン済み';

  @override
  String get myPageOnboardingComplete => '完了';

  @override
  String get myPageOnboardingIncomplete => '未完了';

  @override
  String myPageOnboarding(String status) {
    return 'オンボーディング: $status';
  }

  @override
  String get myPageChangePassword => 'パスワード変更';

  @override
  String get myPageChangePasswordSubtitle => '安全なパスワードで管理してください。';

  @override
  String get myPageNotificationSettings => '通知設定';

  @override
  String get myPageNotificationSettingsSubtitle => 'メールおよびプッシュ通知を設定します。';

  @override
  String get myPageAccountSecurity => 'アカウント / セキュリティ';
}
