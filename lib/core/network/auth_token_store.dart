import 'package:re_view_front/core/storage/web_storage.dart';

class AuthTokenStore {
  static const _keyAccessToken = 'review_access_token';
  static const _keyTokenType = 'review_token_type';

  String? _accessToken = WebStorage.read(_keyAccessToken);
  String? _tokenType = WebStorage.read(_keyTokenType);

  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;

  void save({required String accessToken, required String tokenType}) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    WebStorage.write(_keyAccessToken, accessToken);
    WebStorage.write(_keyTokenType, tokenType);
  }

  void clear() {
    _accessToken = null;
    _tokenType = null;
    WebStorage.remove(_keyAccessToken);
    WebStorage.remove(_keyTokenType);
  }
}
