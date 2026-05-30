import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/storage/web_storage.dart';

class AuthTokenStore extends Notifier<bool> {
  static const _keyAccessToken = 'review_access_token';
  static const _keyTokenType = 'review_token_type';
  static const _keyOnboardingCompleted = 'review_onboarding_completed';
  static const _keyNickname = 'review_nickname';

  String? _accessToken = WebStorage.read(_keyAccessToken);
  String? _tokenType = WebStorage.read(_keyTokenType);
  bool _onboardingCompleted =
      WebStorage.read(_keyOnboardingCompleted) == 'true';
  String? _nickname = WebStorage.read(_keyNickname);

  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;
  bool get onboardingCompleted => _onboardingCompleted;
  String? get nickname => _nickname;

  @override
  bool build() => _accessToken != null;

  void save({
    required String accessToken,
    required String tokenType,
    bool onboardingCompleted = false,
    String? nickname,
  }) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _onboardingCompleted = onboardingCompleted;
    _nickname = nickname;
    WebStorage.write(_keyAccessToken, accessToken);
    WebStorage.write(_keyTokenType, tokenType);
    if (onboardingCompleted) {
      WebStorage.write(_keyOnboardingCompleted, 'true');
    }
    if (nickname != null && nickname.isNotEmpty) {
      WebStorage.write(_keyNickname, nickname);
    }
    state = true;
  }

  void saveNickname(String nickname) {
    _nickname = nickname;
    WebStorage.write(_keyNickname, nickname);
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    WebStorage.write(_keyOnboardingCompleted, 'true');
  }

  void clear() {
    _accessToken = null;
    _tokenType = null;
    _onboardingCompleted = false;
    _nickname = null;
    WebStorage.remove(_keyAccessToken);
    WebStorage.remove(_keyTokenType);
    WebStorage.remove(_keyOnboardingCompleted);
    WebStorage.remove(_keyNickname);
    state = false;
  }
}
