import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<bool> saveString(String key, String val) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, val);
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> val) async {
    return saveString(key, jsonEncode(val));
  }

  static Future<String> getString(String key, [String defaultVal = '']) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? defaultVal;
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      return jsonDecode(await getString(key));
    } catch (_) {
      return {'ERROR': 'Error decoding json'};
    }
  }

  static Future<bool> remove(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}