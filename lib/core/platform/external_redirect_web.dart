import 'dart:html' as html;

void redirectToExternalUrl(Uri uri) {
  html.window.location.assign(uri.toString());
}
