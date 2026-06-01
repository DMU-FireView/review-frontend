import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.width, this.height, this.radius = 0});

  final double? width;
  final double? height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final color = Color.lerp(
          AppColors.surfaceMuted,
          const Color(0xFFE2E8F0),
          _animation.value,
        )!;
        Widget child = ColoredBox(color: color);
        if (widget.radius > 0) {
          child = ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: child,
          );
        }
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: child,
        );
      },
    );
  }
}
