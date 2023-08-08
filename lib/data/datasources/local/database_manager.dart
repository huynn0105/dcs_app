import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  static SharedPreferences? dbInstance;
  static Future<void> init() async {
    dbInstance ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, dynamic value) async {
    if (value is int) {
      await dbInstance!.setInt(key, value);
    } else if (value is String) {
      await dbInstance!.setString(key, value);
    } else if (value is bool) {
      await dbInstance!.setBool(key, value);
    } else {
      debugPrint("Invalid Type");
    }
  }

  static dynamic readData(String key) {
    dynamic obj = dbInstance!.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    return await dbInstance!.remove(key);
  }

  static Future<void> saveJsonData(String key, dynamic value) async {
    var valueJson = jsonEncode(value);
    await dbInstance!.setString(key, valueJson);
  }

  static dynamic readJsonData(String key) {
    dynamic obj = dbInstance!.get(key);
    return obj != null ? jsonDecode(obj) : null;
  }
}