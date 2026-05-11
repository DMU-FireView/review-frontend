enum PasswordResetStep { email, emailSent, newPassword }

enum PasswordResetStatus { idle, loading, success, failure }

class PasswordResetState {
  const PasswordResetState({
    this.step = PasswordResetStep.email,
    this.email = '',
    this.resetToken,
    this.newPassword = '',
    this.confirmPassword = '',
    this.status = PasswordResetStatus.idle,
    this.failureMessage,
  });

  final PasswordResetStep step;
  final String email;
  final String? resetToken;
  final String newPassword;
  final String confirmPassword;
  final PasswordResetStatus status;
  final String? failureMessage;

  bool get isLoading => status == PasswordResetStatus.loading;
  bool get isSuccess => status == PasswordResetStatus.success;

  bool get hasMinLength => newPassword.length >= 8;
  bool get hasLetterAndNumber =>
      RegExp(r'[a-zA-Z]').hasMatch(newPassword) &&
      RegExp(r'[0-9]').hasMatch(newPassword);
  bool get hasSpecialChar =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(newPassword);
  bool get passwordsMatch =>
      newPassword.isNotEmpty && newPassword == confirmPassword;

  PasswordResetState copyWith({
    PasswordResetStep? step,
    String? email,
    String? resetToken,
    bool clearResetToken = false,
    String? newPassword,
    String? confirmPassword,
    PasswordResetStatus? status,
    String? failureMessage,
    bool clearFailureMessage = false,
  }) {
    return PasswordResetState(
      step: step ?? this.step,
      email: email ?? this.email,
      resetToken: clearResetToken ? null : resetToken ?? this.resetToken,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      failureMessage:
          clearFailureMessage ? null : failureMessage ?? this.failureMessage,
    );
  }
}
