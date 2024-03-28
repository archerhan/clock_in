// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///保存数据
  static Future save(String key, Object? value) async {
    SharedPreferences prefs = await _prefs;
    if (value is int) return await prefs.setInt(key, value);
    if (value is String) return await prefs.setString(key, value);
    if (value is bool) return await prefs.setBool(key, value);
  }

  ///获取
  static Future getString(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future remove(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  static Future clear() async {
    SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }
}
