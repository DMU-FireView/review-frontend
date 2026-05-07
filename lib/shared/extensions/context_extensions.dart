import 'package:flutter/material.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

extension BuildContextResponsive on BuildContext {
  Size get viewportSize => MediaQuery.sizeOf(this);

  AppScreenSize get screenSize =>
      AppBreakpoints.screenSizeForWidth(viewportSize.width);

  bool get isMobile => screenSize == AppScreenSize.mobile;

  bool get isTablet => screenSize == AppScreenSize.tablet;

  bool get isDesktop => screenSize == AppScreenSize.desktop;

  EdgeInsets get pagePadding {
    return switch (screenSize) {
      AppScreenSize.mobile => AppSpacing.pageMobile,
      AppScreenSize.tablet => AppSpacing.pageTablet,
      AppScreenSize.desktop => AppSpacing.pageDesktop,
    };
  }

  double get maxContentWidth {
    return switch (screenSize) {
      AppScreenSize.mobile => double.infinity,
      AppScreenSize.tablet => AppBreakpoints.contentMaxWidth,
      AppScreenSize.desktop => AppBreakpoints.wideContentMaxWidth,
    };
  }
}
