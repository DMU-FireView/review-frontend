import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/responsive/responsive_layout.dart';

void main() {
  test('resolves screen size from breakpoint widths', () {
    expect(AppBreakpoints.screenSizeForWidth(375), AppScreenSize.mobile);
    expect(AppBreakpoints.screenSizeForWidth(768), AppScreenSize.tablet);
    expect(AppBreakpoints.screenSizeForWidth(1280), AppScreenSize.desktop);
  });

  test('selects responsive value with fallback order', () {
    expect(
      responsiveValue(
        screenSize: AppScreenSize.mobile,
        mobile: 16,
        tablet: 24,
        desktop: 32,
      ),
      16,
    );
    expect(
      responsiveValue(
        screenSize: AppScreenSize.desktop,
        mobile: 16,
        tablet: 24,
      ),
      24,
    );
  });

  testWidgets('passes current screen size to builder', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    AppScreenSize? capturedSize;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ResponsiveLayout(
          builder: (context, screenSize) {
            capturedSize = screenSize;

            return const SizedBox();
          },
        ),
      ),
    );

    expect(capturedSize, AppScreenSize.mobile);
  });
}
