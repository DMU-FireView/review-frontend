import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';

enum SignupSubmissionStatus { idle, loading, success, autoLoginFailure, failure }

class SignupState {
  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.agreedToTerms = false,
    this.agreedToMarketing = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.passwordConfirmError,
    this.termsError,
    this.failureMessage,
    this.status = SignupSubmissionStatus.idle,
    this.oauthLoadingProvider,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirm;
  final bool agreedToTerms;
  final bool agreedToMarketing;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? passwordConfirmError;
  final String? termsError;
  final String? failureMessage;
  final SignupSubmissionStatus status;
  final OAuthProvider? oauthLoadingProvider;

  bool get isLoading =>
      status == SignupSubmissionStatus.loading || oauthLoadingProvider != null;
  bool get isSuccess => status == SignupSubmissionStatus.success;

  bool isOAuthLoading(OAuthProvider provider) {
    return oauthLoadingProvider == provider;
  }

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirm,
    bool? agreedToTerms,
    bool? agreedToMarketing,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? passwordConfirmError,
    String? termsError,
    String? failureMessage,
    SignupSubmissionStatus? status,
    OAuthProvider? oauthLoadingProvider,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearPasswordConfirmError = false,
    bool clearTermsError = false,
    bool clearFailureMessage = false,
    bool clearOAuthLoadingProvider = false,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      agreedToMarketing: agreedToMarketing ?? this.agreedToMarketing,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
      passwordConfirmError: clearPasswordConfirmError
          ? null
          : passwordConfirmError ?? this.passwordConfirmError,
      termsError: clearTermsError ? null : termsError ?? this.termsError,
      failureMessage: clearFailureMessage
          ? null
          : failureMessage ?? this.failureMessage,
      status: status ?? this.status,
      oauthLoadingProvider: clearOAuthLoadingProvider
          ? null
          : oauthLoadingProvider ?? this.oauthLoadingProvider,
    );
  }
}
