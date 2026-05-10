import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/auth/domain/usecases/login_use_case.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';

class LoginViewModel extends Notifier<LoginState> {
  late final LoginUseCase _loginUseCase;

  @override
  LoginState build() {
    _loginUseCase = ref.watch(loginUseCaseProvider);
    return const LoginState();
  }

  void emailChanged(String value) {
    state = state.copyWith(
      email: value,
      status: LoginSubmissionStatus.idle,
      clearEmailError: true,
      clearFailureMessage: true,
    );
  }

  void passwordChanged(String value) {
    state = state.copyWith(
      password: value,
      status: LoginSubmissionStatus.idle,
      clearPasswordError: true,
      clearFailureMessage: true,
    );
  }

  void rememberMeChanged(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<void> submit() async {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      state = state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        status: LoginSubmissionStatus.idle,
        clearFailureMessage: true,
      );
      return;
    }

    state = state.copyWith(
      status: LoginSubmissionStatus.loading,
      clearFailureMessage: true,
      clearEmailError: true,
      clearPasswordError: true,
    );

    final result = await _loginUseCase(
      email: state.email.trim(),
      password: state.password,
    );

    if (!ref.mounted) {
      return;
    }

    state = result.when(
      success: (_) => state.copyWith(status: LoginSubmissionStatus.success),
      failure: (failure) => state.copyWith(
        status: LoginSubmissionStatus.failure,
        failureMessage: failure.message,
      ),
    );
  }

  String? _validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return '이메일을 입력해주세요.';
    }

    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email)) {
      return '올바른 이메일 형식으로 입력해주세요.';
    }

    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다.';
    }

    return null;
  }
}
