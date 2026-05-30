import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/storage/web_storage.dart';

class AuthTokenStore extends Notifier<bool> {
  static const _keyAccessToken = 'review_access_token';
  static const _keyTokenType = 'review_token_type';
  static const _keyOnboardingCompleted = 'review_onboarding_completed';

  String? _accessToken = WebStorage.read(_keyAccessToken);
  String? _tokenType = WebStorage.read(_keyTokenType);
  bool _onboardingCompleted =
      WebStorage.read(_keyOnboardingCompleted) == 'true';

  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;
  bool get onboardingCompleted => _onboardingCompleted;

  @override
  bool build() => _accessToken != null;

  void save({
    required String accessToken,
    required String tokenType,
    bool onboardingCompleted = false,
  }) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _onboardingCompleted = onboardingCompleted;
    WebStorage.write(_keyAccessToken, accessToken);
    WebStorage.write(_keyTokenType, tokenType);
    if (onboardingCompleted) {
      WebStorage.write(_keyOnboardingCompleted, 'true');
    }
    state = true;
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    WebStorage.write(_keyOnboardingCompleted, 'true');
  }

  void clear() {
    _accessToken = null;
    _tokenType = null;
    _onboardingCompleted = false;
    WebStorage.remove(_keyAccessToken);
    WebStorage.remove(_keyTokenType);
    WebStorage.remove(_keyOnboardingCompleted);
    state = false;
  }
}
