import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeModeKey = 'theme_mode';
  static const _darkValue = 'dark';
  static const _lightValue = 'light';

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_themeModeKey);
      switch (stored) {
        case _lightValue:
          _themeMode = ThemeMode.light;
          break;
        case _darkValue:
        default:
          _themeMode = ThemeMode.dark;
          break;
      }
    } catch (_) {
      _themeMode = ThemeMode.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final value = mode == ThemeMode.light ? _lightValue : _darkValue;
      await prefs.setString(_themeModeKey, value);
    } catch (_) {
      // Theme persistence should never block UI interactions.
    }
  }
}
