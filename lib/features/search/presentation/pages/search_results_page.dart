import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    final keyword = query.trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AppContentView(
          maxWidth: 1200,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            keyword.isEmpty ? '검색어를 입력해 주세요' : '"$keyword" 검색 결과',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
