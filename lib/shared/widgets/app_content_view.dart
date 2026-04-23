import 'package:flutter/material.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class AppContentView extends StatelessWidget {
  const AppContentView({
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.center,
    super.key,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.maxContentWidth,
        ),
        child: Padding(padding: padding ?? context.pagePadding, child: child),
      ),
    );
  }
}
