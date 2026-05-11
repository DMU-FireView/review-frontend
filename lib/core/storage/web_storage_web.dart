import 'dart:html' as html;

class WebStorage {
  static String? read(String key) => html.window.localStorage[key];
  static void write(String key, String value) =>
      html.window.localStorage[key] = value;
  static void remove(String key) => html.window.localStorage.remove(key);
}
