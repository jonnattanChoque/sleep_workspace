import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _themeKey = 'is_dark_mode';
  static const _tourPrefix = 'tour_completed_';
  static const _lastSyncKey = 'last_sleep_sync_date';
  static const myLogsKey = 'my_local_logs';
  static const partnerLogsKey = 'partner_local_logs';

  Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }

  Future<void> setTourCompleted(String tourName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_tourPrefix$tourName', true);
  }

  Future<bool> isTourCompleted(String tourName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_tourPrefix$tourName') ?? false;
  }

  Future<void> clearAllTours() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_tourPrefix));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }

  Future<void> setLastSyncDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, date);
  }

  Future<String?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSyncKey);
  }

  Future<void> saveSleepLogs(String key, List<dynamic> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(logs); 
    await prefs.setString(key, encodedData);
  }

  Future<String?> getSleepLogs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}