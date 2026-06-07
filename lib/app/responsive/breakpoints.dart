enum AppScreenSize { mobile, tablet, desktop }

abstract final class AppBreakpoints {
  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1023;
  static const double desktopMin = 1024;

  static const double authMaxWidth = 420;
  static const double contentMaxWidth = 960;
  static const double wideContentMaxWidth = 1200;

  static AppScreenSize screenSizeForWidth(double width) {
    if (width <= mobileMax) {
      return AppScreenSize.mobile;
    }

    if (width <= tabletMax) {
      return AppScreenSize.tablet;
    }

    return AppScreenSize.desktop;
  }

  static bool isMobile(double width) =>
      screenSizeForWidth(width) == AppScreenSize.mobile;

  static bool isTablet(double width) =>
      screenSizeForWidth(width) == AppScreenSize.tablet;

  static bool isDesktop(double width) =>
      screenSizeForWidth(width) == AppScreenSize.desktop;
}
