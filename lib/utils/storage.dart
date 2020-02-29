import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as Convert;

class Storage {

  static Future<dynamic> getValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    dynamic value = sp.getString(key);
    if (value != null) {
      return Convert.jsonDecode(value);
    }
  }

  static Future<void> setValue(String key, dynamic value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (value != null) {
      sp.setString(key, Convert.jsonEncode(value));
    }
  }

  static Future<void> remove(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  static Future<void> clear() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}