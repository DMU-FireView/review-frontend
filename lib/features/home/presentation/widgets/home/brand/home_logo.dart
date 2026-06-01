import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/home/brand/review_web_header_logo.png',
      height: 32,
      fit: BoxFit.contain,
    );

    if (onTap == null) {
      return logo;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: logo,
      ),
    );
  }
}
