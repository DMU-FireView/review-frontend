final Map<String, String> _memory = {};

class WebStorage {
  static String? read(String key) => _memory[key];
  static void write(String key, String value) => _memory[key] = value;
  static void remove(String key) => _memory.remove(key);
}
