import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/send_password_reset_request_use_case.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';

class PasswordResetViewModel extends Notifier<PasswordResetState> {
  late final SendPasswordResetRequestUseCase _sendResetRequest;
  late final ResetPasswordUseCase _resetPassword;

  @override
  PasswordResetState build() {
    _sendResetRequest = ref.watch(sendPasswordResetRequestUseCaseProvider);
    _resetPassword = ref.watch(resetPasswordUseCaseProvider);
    return const PasswordResetState();
  }

  void emailChanged(String value) {
    state = state.copyWith(
      email: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  void newPasswordChanged(String value) {
    state = state.copyWith(
      newPassword: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  void confirmPasswordChanged(String value) {
    state = state.copyWith(
      confirmPassword: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  Future<void> sendVerificationCode() async {
    final email = state.email.trim();
    if (email.isEmpty || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '유효한 이메일 주소를 입력해 주세요.',
      );
      return;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearFailureMessage: true,
    );

    final result = await _sendResetRequest(email);

    if (!ref.mounted) return;

    state = result.when(
      success: (resetToken) => state.copyWith(
        status: PasswordResetStatus.idle,
        step: PasswordResetStep.emailSent,
        resetToken: resetToken,
      ),
      failure: (failure) => state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: failure.message,
      ),
    );
  }

  void proceedToNewPassword() {
    state = state.copyWith(step: PasswordResetStep.newPassword);
  }

  Future<void> resetPassword() async {
    if (!state.hasMinLength || !state.hasLetterAndNumber) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '비밀번호 조건을 확인해 주세요.',
      );
      return;
    }
    if (!state.passwordsMatch) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '비밀번호가 일치하지 않습니다.',
      );
      return;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearFailureMessage: true,
    );

    final result = await _resetPassword(
      token: state.resetToken!,
      newPassword: state.newPassword,
    );

    if (!ref.mounted) return;

    state = result.when(
      success: (_) => state.copyWith(status: PasswordResetStatus.success),
      failure: (failure) => state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: failure.message,
      ),
    );
  }

  Future<void> resendCode() async {
    state = state.copyWith(
      step: PasswordResetStep.email,
      resetToken: null,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }
}
