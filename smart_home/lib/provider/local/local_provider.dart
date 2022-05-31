import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/model/device.dart';

class LocalKeys {
  static const accessToken = 'token';
  static const refreshToken = 'r_token';
  static const devices = 'devices';
}

abstract class LocalProvider {
  Future<void> removeDataWithKey(String key);

  Future<bool> saveData(String key, dynamic data);

  Future<dynamic> getDataWithKey(String key);

  Future<List<Device>> getDevices();
}

class LocalProviderImpl implements LocalProvider {
  @override
  Future getDataWithKey(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.get(key);
  }

  @override
  Future<bool> saveData(String key, dynamic value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (value is String) {
      return await preferences.setString(key, value);
    }
    if (value is int) {
      return await preferences.setInt(key, value);
    }
    if (value is double) {
      return await preferences.setDouble(key, value);
    }
    if (value is bool) {
      return await preferences.setBool(key, value);
    }
    if (value is List<String>) {
      return await preferences.setStringList(key, value);
    }

    return false;
  }

  @override
  Future<void> removeDataWithKey(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(key);
  }

  @override
  Future<List<Device>> getDevices() async {
    List<Device> devices = [];

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final rawData = preferences.getStringList(LocalKeys.devices);
    if (rawData != null) {
      rawData.forEach((element) {
        devices.add(Device.fromJson(jsonDecode(element)));
      });
    }
    return devices;
  }
}
