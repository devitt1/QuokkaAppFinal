import 'package:shared_preferences/shared_preferences.dart';

Future<String?> storageGet(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString(key);
  return action;
}

Future<bool> storageSet(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}
