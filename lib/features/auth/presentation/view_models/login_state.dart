import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';

enum LoginSubmissionStatus { idle, loading, success, failure }

class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = true,
    this.emailError,
    this.passwordError,
    this.failureMessage,
    this.status = LoginSubmissionStatus.idle,
    this.oauthLoadingProvider,
  });

  final String email;
  final String password;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final String? failureMessage;
  final LoginSubmissionStatus status;
  final OAuthProvider? oauthLoadingProvider;

  bool get isLoading =>
      status == LoginSubmissionStatus.loading || oauthLoadingProvider != null;
  bool get isSuccess => status == LoginSubmissionStatus.success;
  bool isOAuthLoading(OAuthProvider provider) =>
      oauthLoadingProvider == provider;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
    String? failureMessage,
    LoginSubmissionStatus? status,
    OAuthProvider? oauthLoadingProvider,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearFailureMessage = false,
    bool clearOAuthLoadingProvider = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
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
