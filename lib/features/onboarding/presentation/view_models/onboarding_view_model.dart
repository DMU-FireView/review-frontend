import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/onboarding/domain/entities/interest_category.dart';
import 'package:re_view_front/features/onboarding/domain/entities/notification_channel.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';

class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void toggleCategory(InterestCategory category) {
    final updated = Set<InterestCategory>.from(state.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    state = state.copyWith(selectedCategories: updated);
  }

  void toggleLowTrustReviewAlert() {
    state = state.copyWith(lowTrustReviewAlert: !state.lowTrustReviewAlert);
  }

  void toggleRiskSurgeAlert() {
    state = state.copyWith(riskSurgeAlert: !state.riskSurgeAlert);
  }

  void toggleAnalysisCompleteAlert() {
    state =
        state.copyWith(analysisCompleteAlert: !state.analysisCompleteAlert);
  }

  void toggleWeeklyReportAlert() {
    state = state.copyWith(weeklyReportAlert: !state.weeklyReportAlert);
  }

  void toggleMarketingAlert() {
    state = state.copyWith(marketingAlert: !state.marketingAlert);
  }

  void toggleChannel(NotificationChannel channel) {
    final updated = Set<NotificationChannel>.from(state.selectedChannels);
    if (updated.contains(channel)) {
      updated.remove(channel);
    } else {
      updated.add(channel);
    }
    state = state.copyWith(selectedChannels: updated);
  }

  void goToNotificationStep() {
    if (!state.canProceed) return;
    state = state.copyWith(step: OnboardingStep.notification);
  }

  void goToCategoryStep() {
    state = state.copyWith(step: OnboardingStep.category);
  }

  Future<void> complete() async {
    state = state.copyWith(
      status: OnboardingSubmitStatus.loading,
      clearFailureMessage: true,
    );

    // TODO: call API when spec is confirmed
    // final result = await _repository.savePreferences(
    //   categories: state.selectedCategories,
    //   lowTrustReviewAlert: state.lowTrustReviewAlert,
    //   riskSurgeAlert: state.riskSurgeAlert,
    //   analysisCompleteAlert: state.analysisCompleteAlert,
    //   weeklyReportAlert: state.weeklyReportAlert,
    //   marketingAlert: state.marketingAlert,
    //   channels: state.selectedChannels,
    // );

    if (!ref.mounted) return;
    state = state.copyWith(status: OnboardingSubmitStatus.success);
  }
}
