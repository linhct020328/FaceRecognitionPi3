//import 'package:shared_preferences/shared_preferences.dart';
//
//
//abstract class LocalProvider {
//  Future<void> removeDataWithKey(String key);
//
//  Future<bool> saveData(String key, String data);
//
//  Future<dynamic> getDataWithKey(String key);
//}
//
//class SharedPrefsProviderImpl implements LocalProvider {
//  @override
//  Future getDataWithKey(String key) async {
//    final SharedPreferences preferences = await SharedPreferences.getInstance();
//    return await preferences.get(key);
//  }
//
//  @override
//  Future<bool> saveData(String key, dynamic value) async {
//    final SharedPreferences preferences = await SharedPreferences.getInstance();
//    if (value is String) {
//      return await preferences.setString(key, value);
//    }
//    if (value is int) {
//      return await preferences.setInt(key, value);
//    }
//    if (value is double) {
//      return await preferences.setDouble(key, value);
//    }
//    if (value is bool) {
//      return await preferences.setBool(key, value);
//    }
//    if (value is List<String>) {
//      return await preferences.setStringList(key, value);
//    }
//
//    return false;
//  }
//
//  @override
//  Future<void> removeDataWithKey(String key) async {
//    final SharedPreferences preferences = await SharedPreferences.getInstance();
//    return await preferences.remove(key);
//  }
//}
