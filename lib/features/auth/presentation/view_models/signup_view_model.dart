import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/domain/usecases/login_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/signup_use_case.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_state.dart';

class SignupViewModel extends Notifier<SignupState> {
  late final SignupUseCase _signupUseCase;
  late final LoginUseCase _loginUseCase;

  @override
  SignupState build() {
    _signupUseCase = ref.watch(signupUseCaseProvider);
    _loginUseCase = ref.watch(loginUseCaseProvider);
    return const SignupState();
  }

  void nameChanged(String value) {
    state = state.copyWith(
      name: value,
      status: SignupSubmissionStatus.idle,
      clearNameError: true,
      clearFailureMessage: true,
    );
  }

  void emailChanged(String value) {
    state = state.copyWith(
      email: value,
      status: SignupSubmissionStatus.idle,
      clearEmailError: true,
      clearFailureMessage: true,
    );
  }

  void passwordChanged(String value) {
    state = state.copyWith(
      password: value,
      status: SignupSubmissionStatus.idle,
      clearPasswordError: true,
      clearPasswordConfirmError: true,
      clearFailureMessage: true,
    );
  }

  void passwordConfirmChanged(String value) {
    state = state.copyWith(
      passwordConfirm: value,
      status: SignupSubmissionStatus.idle,
      clearPasswordConfirmError: true,
      clearFailureMessage: true,
    );
  }

  void termsChanged(bool value) {
    state = state.copyWith(
      agreedToTerms: value,
      status: SignupSubmissionStatus.idle,
      clearTermsError: true,
      clearFailureMessage: true,
    );
  }

  void marketingChanged(bool value) {
    state = state.copyWith(agreedToMarketing: value);
  }

  Future<void> submit() async {
    final nameError = _validateName(state.name);
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);
    final passwordConfirmError = _validatePasswordConfirm(
      state.password,
      state.passwordConfirm,
    );
    final termsError = state.agreedToTerms ? null : '필수 약관에 동의해주세요.';

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        passwordConfirmError != null ||
        termsError != null) {
      state = state.copyWith(
        nameError: nameError,
        emailError: emailError,
        passwordError: passwordError,
        passwordConfirmError: passwordConfirmError,
        termsError: termsError,
        status: SignupSubmissionStatus.idle,
        clearFailureMessage: true,
      );
      return;
    }

    state = state.copyWith(
      status: SignupSubmissionStatus.loading,
      clearNameError: true,
      clearEmailError: true,
      clearPasswordError: true,
      clearPasswordConfirmError: true,
      clearTermsError: true,
      clearFailureMessage: true,
    );

    final email = state.email.trim();
    final password = state.password;

    final result = await _signupUseCase(
      name: state.name.trim(),
      email: email,
      password: password,
    );

    if (!ref.mounted) return;

    switch (result) {
      case FailureResult(:final failure):
        state = state.copyWith(
          status: SignupSubmissionStatus.failure,
          failureMessage: failure.message,
        );
        return;
      case Success():
        break;
    }

    final loginResult = await _loginUseCase(email: email, password: password);

    if (!ref.mounted) return;

    state = loginResult.when(
      success: (_) => state.copyWith(status: SignupSubmissionStatus.success),
      failure: (_) =>
          state.copyWith(status: SignupSubmissionStatus.autoLoginFailure),
    );
  }

  Future<Uri?> startOAuth(OAuthProvider provider) async {
    state = state.copyWith(
      oauthLoadingProvider: provider,
      status: SignupSubmissionStatus.idle,
      clearNameError: true,
      clearEmailError: true,
      clearPasswordError: true,
      clearPasswordConfirmError: true,
      clearTermsError: true,
      clearFailureMessage: true,
    );

    final result = await _signupUseCase.startOAuth(provider);

    if (!ref.mounted) {
      return null;
    }

    return result.when(
      success: (uri) {
        state = state.copyWith(clearOAuthLoadingProvider: true);
        return uri;
      },
      failure: (failure) {
        state = state.copyWith(
          status: SignupSubmissionStatus.failure,
          failureMessage: failure.message,
          clearOAuthLoadingProvider: true,
        );
        return null;
      },
    );
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) {
      return '이름을 입력해주세요.';
    }

    return null;
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

    final hasLetter = RegExp('[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return '영문, 숫자, 특수문자를 모두 포함해주세요.';
    }

    return null;
  }

  String? _validatePasswordConfirm(String password, String confirm) {
    if (confirm.isEmpty) {
      return '비밀번호를 한 번 더 입력해주세요.';
    }

    if (password != confirm) {
      return '비밀번호가 일치하지 않습니다.';
    }

    return null;
  }
}
