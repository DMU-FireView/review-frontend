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
  });

  final String email;
  final String password;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final String? failureMessage;
  final LoginSubmissionStatus status;

  bool get isLoading => status == LoginSubmissionStatus.loading;
  bool get isSuccess => status == LoginSubmissionStatus.success;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
    String? failureMessage,
    LoginSubmissionStatus? status,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearFailureMessage = false,
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
    );
  }
}
