enum OAuthProvider { naver, google }

extension OAuthProviderLabel on OAuthProvider {
  String get label {
    return switch (this) {
      OAuthProvider.naver => '네이버',
      OAuthProvider.google => 'Google',
    };
  }
}
