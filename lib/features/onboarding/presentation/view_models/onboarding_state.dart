import 'package:re_view_front/features/onboarding/domain/entities/interest_category.dart';
import 'package:re_view_front/features/onboarding/domain/entities/notification_channel.dart';

enum OnboardingStep { category, notification }

enum OnboardingSubmitStatus { idle, loading, success, failure }

class OnboardingState {
  const OnboardingState({
    this.step = OnboardingStep.category,
    this.selectedCategories = const {},
    this.lowTrustReviewAlert = true,
    this.riskSurgeAlert = true,
    this.analysisCompleteAlert = true,
    this.weeklyReportAlert = true,
    this.marketingAlert = false,
    this.selectedChannels = const {
      NotificationChannel.appPush,
      NotificationChannel.email,
    },
    this.status = OnboardingSubmitStatus.idle,
    this.failureMessage,
  });

  final OnboardingStep step;
  final Set<InterestCategory> selectedCategories;
  final bool lowTrustReviewAlert;
  final bool riskSurgeAlert;
  final bool analysisCompleteAlert;
  final bool weeklyReportAlert;
  final bool marketingAlert;
  final Set<NotificationChannel> selectedChannels;
  final OnboardingSubmitStatus status;
  final String? failureMessage;

  bool get canProceed => selectedCategories.isNotEmpty;
  bool get isLoading => status == OnboardingSubmitStatus.loading;
  bool get isSuccess => status == OnboardingSubmitStatus.success;

  OnboardingState copyWith({
    OnboardingStep? step,
    Set<InterestCategory>? selectedCategories,
    bool? lowTrustReviewAlert,
    bool? riskSurgeAlert,
    bool? analysisCompleteAlert,
    bool? weeklyReportAlert,
    bool? marketingAlert,
    Set<NotificationChannel>? selectedChannels,
    OnboardingSubmitStatus? status,
    String? failureMessage,
    bool clearFailureMessage = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      lowTrustReviewAlert: lowTrustReviewAlert ?? this.lowTrustReviewAlert,
      riskSurgeAlert: riskSurgeAlert ?? this.riskSurgeAlert,
      analysisCompleteAlert:
          analysisCompleteAlert ?? this.analysisCompleteAlert,
      weeklyReportAlert: weeklyReportAlert ?? this.weeklyReportAlert,
      marketingAlert: marketingAlert ?? this.marketingAlert,
      selectedChannels: selectedChannels ?? this.selectedChannels,
      status: status ?? this.status,
      failureMessage: clearFailureMessage
          ? null
          : failureMessage ?? this.failureMessage,
    );
  }
}
