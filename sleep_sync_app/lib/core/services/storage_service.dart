import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _themeKey = 'is_dark_mode';
  static const _notificationsKey = 'notifications_enabled';
  static const _tourPrefix = 'tour_completed_';

  Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<bool?> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey);
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
}