// shared_prefrences_singleton.dart
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Add this public getter
  static SharedPreferences get prefs => _prefs;

  // Existing methods
  static setBool(String key, bool value) => _prefs.setBool(key, value);
  static bool getBool(String key) => _prefs.getBool(key) ?? false;

  static Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  static String getString(String key) => _prefs.getString(key) ?? '';
}
