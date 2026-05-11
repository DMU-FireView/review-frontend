import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/onboarding/domain/entities/interest_category.dart';
import 'package:re_view_front/features/onboarding/domain/entities/notification_channel.dart';
import 'package:re_view_front/features/onboarding/domain/repositories/onboarding_repository.dart';

// TODO: implement when API spec is confirmed
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl();

  @override
  Future<Result<bool>> savePreferences({
    required Set<InterestCategory> categories,
    required bool lowTrustReviewAlert,
    required bool riskSurgeAlert,
    required bool analysisCompleteAlert,
    required bool weeklyReportAlert,
    required bool marketingAlert,
    required Set<NotificationChannel> channels,
  }) async {
    throw UnimplementedError('API spec not yet confirmed');
  }
}
