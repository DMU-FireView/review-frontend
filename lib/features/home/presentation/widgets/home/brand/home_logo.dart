import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final logo = Text(
      'Re:view',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w900,
      ),
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
