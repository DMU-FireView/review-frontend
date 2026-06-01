import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
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

    try {
      final apiClient = ref.read(apiClientProvider);
      final categories = state.selectedCategories
          .map(_toApiCategory)
          .whereType<String>()
          .toList();

      await apiClient.post(
        '/api/onboarding/preferences',
        data: {
          'preferredCategories': categories,
          'minTrustScore': 60,
        },
      );

      ref.read(authTokenStoreProvider.notifier).completeOnboarding();
    } on DioException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: OnboardingSubmitStatus.failure,
        failureMessage: e.response?.data?['message'] ?? '온보딩 저장에 실패했습니다.',
      );
      return;
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: OnboardingSubmitStatus.failure,
        failureMessage: '온보딩 저장에 실패했습니다.',
      );
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(status: OnboardingSubmitStatus.success);
  }

  String? _toApiCategory(InterestCategory category) {
    return switch (category) {
      InterestCategory.digital => 'DIGITAL_HOME_APPLIANCE',
      InterestCategory.fashion => 'FASHION_WOMEN',
      InterestCategory.beauty => 'BEAUTY_SKINCARE',
      InterestCategory.food => 'FOOD_FRESH',
      InterestCategory.living => 'LIVING_DAILY',
      InterestCategory.pet => 'PET_DOG',
      InterestCategory.travel => 'TRAVEL_GOODS',
      InterestCategory.kids => 'BABY_NEWBORN',
    };
  }
}
