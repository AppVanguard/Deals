import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  /// Call this once in `main()` before using any helper.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Raw access if you ever need it.
  static SharedPreferences get prefs => _prefs;

  // ─────────────────────────────────────────────────────────────────────────────
  // Bool helpers
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  static bool getBool(String key) => _prefs.getBool(key) ?? false;

  // ─────────────────────────────────────────────────────────────────────────────
  // String helpers
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  static String getString(String key) => _prefs.getString(key) ?? '';

  // ─────────────────────────────────────────────────────────────────────────────
  // NEW: key removal and full wipe
  // ─────────────────────────────────────────────────────────────────────────────
  /// Delete a single key – used for resetting “notificationsRegistered_<uid>”.
  static Future<void> remove(String key) => _prefs.remove(key);

  /// Clear *everything* (use with care).
  static Future<void> clear() => _prefs.clear();
}
