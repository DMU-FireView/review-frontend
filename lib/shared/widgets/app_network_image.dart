import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholderIcon = Icons.image_outlined,
    this.iconSize = 28.0,
    this.borderRadius,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final Alignment alignment;
  final IconData placeholderIcon;
  final double iconSize;
  final BorderRadius? borderRadius;

  String get _objectFit => switch (fit) {
    BoxFit.contain => 'contain',
    BoxFit.fill => 'fill',
    BoxFit.fitWidth => 'cover',
    BoxFit.fitHeight => 'contain',
    BoxFit.none => 'none',
    _ => 'cover',
  };

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (url.isEmpty) {
      child = _Placeholder(icon: placeholderIcon, iconSize: iconSize);
    } else if (kIsWeb) {
      // HtmlElementView로 <img> 태그 직접 렌더링 → 외부 CDN 이미지 CORS 우회
      final objectFit = _objectFit;
      child = HtmlElementView.fromTagName(
        tagName: 'img',
        onElementCreated: (Object element) {
          final img = element as dynamic;
          img.src = url;
          img.style.width = '100%';
          img.style.height = '100%';
          img.style.objectFit = objectFit;
          img.style.display = 'block';
        },
      );
    } else {
      child = Image.network(
        url,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (context, widget, loadingProgress) {
          if (loadingProgress == null) return widget;
          return const _Shimmer();
        },
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(icon: placeholderIcon, iconSize: iconSize),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer();

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
      builder: (context, _) => ColoredBox(
        color: Color.lerp(
          AppColors.surfaceMuted,
          const Color(0xFFE2E8F0),
          _animation.value,
        )!,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.iconSize});

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
