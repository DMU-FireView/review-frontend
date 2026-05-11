enum OAuthCallbackStatus { processing, success, failure }

class OAuthCallbackState {
  const OAuthCallbackState({
    this.status = OAuthCallbackStatus.processing,
    this.onboardingCompleted = false,
    this.errorMessage,
  });

  final OAuthCallbackStatus status;
  final bool onboardingCompleted;
  final String? errorMessage;

  OAuthCallbackState copyWith({
    OAuthCallbackStatus? status,
    bool? onboardingCompleted,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OAuthCallbackState(
      status: status ?? this.status,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
