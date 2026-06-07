import 'package:flutter/widgets.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, AppScreenSize screenSize);

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({required this.builder, super.key});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = AppBreakpoints.screenSizeForWidth(
          constraints.maxWidth,
        );

        return builder(context, screenSize);
      },
    );
  }
}

T responsiveValue<T>({
  required AppScreenSize screenSize,
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  return switch (screenSize) {
    AppScreenSize.mobile => mobile,
    AppScreenSize.tablet => tablet ?? mobile,
    AppScreenSize.desktop => desktop ?? tablet ?? mobile,
  };
}
