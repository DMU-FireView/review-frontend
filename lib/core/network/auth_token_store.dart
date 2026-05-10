class AuthTokenStore {
  String? _accessToken;
  String? _tokenType;

  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;

  void save({required String accessToken, required String tokenType}) {
    _accessToken = accessToken;
    _tokenType = tokenType;
  }

  void clear() {
    _accessToken = null;
    _tokenType = null;
  }
}
