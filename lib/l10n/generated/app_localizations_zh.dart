// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => '首页';

  @override
  String get navSearch => '搜索';

  @override
  String get navCart => '购物车';

  @override
  String get navWishlist => '收藏';

  @override
  String get navMyPage => '我的页面';

  @override
  String get navSettings => '设置';

  @override
  String get actionSave => '保存';

  @override
  String get actionCancel => '取消';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionRetry => '重试';

  @override
  String get actionBack => '返回';

  @override
  String get actionLogin => '登录';

  @override
  String get actionLogout => '退出登录';

  @override
  String get actionSignup => '注册';

  @override
  String get actionViewAll => '查看全部';

  @override
  String get stateLoading => '加载中…';

  @override
  String get stateError => '发生错误。';

  @override
  String get stateEmpty => '暂无内容。';

  @override
  String get settingsSaved => '设置已保存。';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsNotifications => '通知设置';

  @override
  String get settingsFilters => '分析筛选设置';

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
  String get sideNavFeedbackHistory => '反馈记录';

  @override
  String get settingsSubtitle => '管理通知、过滤器和账户设置。';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '管理$nickname的通知、过滤器和账户设置。';
  }

  @override
  String get settingsNotificationEmail => '接收邮件通知';

  @override
  String get settingsNotificationEmailDesc => '通过邮件接收商品价格变动和评价更新。';

  @override
  String get settingsNotificationPush => '接收应用推送通知';

  @override
  String get settingsNotificationPushDesc => '在浏览器中接收已保存商品的实时通知。';

  @override
  String get settingsNotificationAdEmail => '接收邮件广告';

  @override
  String get settingsNotificationAdEmailDesc => '通过邮件接收促销和专属优惠信息。';

  @override
  String get settingsFilterHighlightLowRti => '优先显示注意商品';

  @override
  String get settingsFilterHighlightLowRtiDesc => '将评价可信度较低的商品显示在列表顶部。';

  @override
  String get settingsFilterWishlistAlert => '接收已保存商品通知';

  @override
  String get settingsFilterWishlistAlertDesc => '当收藏商品的RTI发生变化时发送通知。';

  @override
  String get settingsFilterCategory => '分类过滤器';

  @override
  String get settingsFilterCategoryDesc => '优先显示所选分类商品的分析结果。';

  @override
  String get settingsFilterCategoryAll => '全部分类';

  @override
  String get settingsFilterMinReview => '最低评价数量';

  @override
  String get settingsFilterMinReviewDesc => '仅将拥有该数量以上评价的商品纳入分析结果。';

  @override
  String get settingsFilterMinReviewSuffix => '条';

  @override
  String get settingsFilterLowRti => '低RTI警告标准';

  @override
  String get settingsFilterLowRtiDesc => 'RTI分数低于此值的商品将被分类为注意商品。';

  @override
  String get settingsFilterLowRtiSuffix => '分';

  @override
  String get settingsAccountTitle => '账户';

  @override
  String get settingsAccountChangePassword => '更改密码';

  @override
  String get settingsAccountLabelName => '姓名';

  @override
  String get settingsAccountLabelEmail => '邮箱';

  @override
  String get settingsAccountLabelJoinDate => '注册日期';

  @override
  String get settingsAccountLabelMemberType => '会员类型';

  @override
  String get settingsAccountDefaultName => '用户';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role会员';
  }

  @override
  String get settingsAccountLinkedServices => '关联服务';

  @override
  String get settingsAccountConnected => '已关联';

  @override
  String get settingsAccountDisconnected => '未关联';

  @override
  String get settingsLanguageSection => '语言设置';

  @override
  String get settingsLanguageApplyNow => '更改将立即生效。';

  @override
  String get settingsSavedFeedback => '已保存';

  @override
  String get wishlistTitle => '收藏商品';

  @override
  String get wishlistSubtitle => '一目了然地查看已保存的商品，确认价格和评价可信度。';

  @override
  String wishlistCount(int count) {
    return '收藏商品$count件';
  }

  @override
  String get wishlistEmpty => '暂无收藏商品';

  @override
  String get wishlistEmptyDesc => '点击商品卡片上的爱心即可添加到收藏列表。';

  @override
  String get wishlistBrowse => '去浏览商品';

  @override
  String get wishlistFilteredEmpty => '没有符合所选过滤条件的收藏商品。';

  @override
  String get wishlistSummaryTitle => '收藏列表概览';

  @override
  String wishlistSummaryTotal(int count) {
    return '共$count件';
  }

  @override
  String get wishlistSummaryPriceDrop => '价格下降';

  @override
  String get wishlistSummaryNewAlert => '新通知';

  @override
  String get wishlistSummaryTotalReview => '总评价';

  @override
  String get wishlistProductView => '查看商品';

  @override
  String get wishlistProductPriceDrop => '价格下降';

  @override
  String get wishlistSortRecent => '最近保存';

  @override
  String get wishlistSortPriceLow => '价格从低到高';

  @override
  String get wishlistSortPriceHigh => '价格从高到低';

  @override
  String get wishlistSortRti => 'RTI从高到低';

  @override
  String get wishlistSortReviewCount => '评价最多';

  @override
  String get wishlistFilterAll => '全部';

  @override
  String get wishlistFilterPriceDrop => '价格下降';

  @override
  String get wishlistFilterRti => 'RTI分数';

  @override
  String get wishlistFilterLowestPrice => '最低价格';

  @override
  String get wishlistFilterBrand => '品牌';

  @override
  String get wishlistFilterCategory => '分类';

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
  String get navCategory => '分类';

  @override
  String get navWishShort => '收藏';

  @override
  String get navMyShort => '我的';

  @override
  String get homeSearchHint => '基于评价搜索商品';

  @override
  String get homeSearchSuggestionsTitle => '相关搜索词';

  @override
  String get homeSearchSuggestionsLoading => '正在加载相关搜索词。';

  @override
  String get homeSearchSuggestionsHint => '输入2个以上字符即可显示相关搜索词。';

  @override
  String get homeRecentSearchTitle => '最近搜索';

  @override
  String get homeRecentSearchDeleteAll => '全部删除';

  @override
  String get homeRecentSearchEmpty => '暂无最近搜索词。';

  @override
  String get homePopularSearchTitle => '热门搜索';

  @override
  String get homeSearchProductsTitle => '推荐商品';

  @override
  String get homeTrendingTitle => '热门搜索关键词';

  @override
  String get homeKeywordsEmpty => '暂无可显示的关键词。';

  @override
  String get homeRecommendedTitle => '编辑精选基于评价的推荐商品';

  @override
  String get homeViewAll => '查看全部';

  @override
  String get homeLoginRequired => '需要登录。';

  @override
  String get homeBenefitTitle => '首次购买专属优惠';

  @override
  String get homeBenefitSubtitle => '开始基于评价的购物即可享受会员福利。';

  @override
  String get homeBenefitButton => '领取优惠';

  @override
  String get homeTrustDescription => '过滤广告和操纵评价，分析真实用户评价并提供可信度。';

  @override
  String get homeTrustViewMore => '了解更多';

  @override
  String get homeTrustLabel1 => '真实评价分析';

  @override
  String get homeTrustLabel2 => '广告/操纵过滤';

  @override
  String get homeTrustLabel3 => '可信度评分提供';

  @override
  String get homePopularCategoryTitle => '热门分类';

  @override
  String get homeCategoryEmpty => '暂无可显示的分类。';

  @override
  String get feedbackHistoryTitle => '我的反馈记录';

  @override
  String get feedbackHistorySubtitle => '查看您提交的商品/评论反馈记录。';

  @override
  String get feedbackHistoryLoading => '正在加载反馈记录。';

  @override
  String get feedbackHistoryEmpty => '暂无提交的反馈。';

  @override
  String get feedbackHistoryEmptyDesc => '您可以在商品详情页提交评论反馈。';

  @override
  String feedbackHistoryCount(int count) {
    return '$count条反馈';
  }

  @override
  String get feedbackHistoryViewProduct => '查看商品';

  @override
  String get feedbackStatusSubmitted => '已提交';

  @override
  String get feedbackStatusPending => '审核中';

  @override
  String get feedbackStatusAccepted => '已处理';

  @override
  String get feedbackStatusRejected => '已拒绝';
}
