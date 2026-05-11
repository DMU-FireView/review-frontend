import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/oauth_callback_state.dart';

class OAuthCallbackViewModel
    extends AutoDisposeNotifier<OAuthCallbackState> {
  @override
  OAuthCallbackState build() => const OAuthCallbackState();

  Future<void> processCallback(Map<String, String> queryParams) async {
    final error = queryParams['error'];
    if (error != null) {
      state = state.copyWith(
        status: OAuthCallbackStatus.failure,
        errorMessage: _mapError(error),
      );
      return;
    }

    final accessToken = queryParams['accessToken'];
    if (accessToken == null || accessToken.isEmpty) {
      state = state.copyWith(
        status: OAuthCallbackStatus.failure,
        errorMessage: '인증 정보를 받지 못했습니다. 다시 시도해주세요.',
      );
      return;
    }

    final result = await ref
        .read(handleOAuthCallbackUseCaseProvider)
        .call(
          accessToken: accessToken,
          tokenType: queryParams['tokenType'] ?? 'Bearer',
          email: queryParams['email'] ?? '',
          nickname: queryParams['nickname'] ?? '',
          onboardingCompleted:
              queryParams['onboardingCompleted'] == 'true',
        );

    if (!ref.mounted) return;

    state = result.when(
      success: (user) => state.copyWith(
        status: OAuthCallbackStatus.success,
        onboardingCompleted: user.onboardingCompleted,
      ),
      failure: (failure) => state.copyWith(
        status: OAuthCallbackStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  String _mapError(String error) {
    return switch (error) {
      'access_denied' => 'OAuth 로그인을 취소했습니다.',
      'server_error' => '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      _ => 'OAuth 로그인 중 오류가 발생했습니다.',
    };
  }
}
