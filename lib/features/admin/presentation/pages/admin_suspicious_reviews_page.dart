import 'package:flutter/material.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminSuspiciousReviewsPage extends StatelessWidget {
  const AdminSuspiciousReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminPageScaffold(
      title: l10n.adminMenuSuspiciousReviews,
      body: AdminEmptyBody(message: l10n.adminPlaceholderMessage),
    );
  }
}
