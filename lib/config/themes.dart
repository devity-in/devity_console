import 'package:flutter/material.dart';

/// Custom primary color
const Color primaryColor = Color(0xFF1C1536);

/// Light theme data
ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: Colors.deepPurple.shade200,
      ),
      useMaterial3: true,
    );

/// Dark theme data
ThemeData get darkTheme => ThemeData(
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: Colors.deepPurple.shade200,
        surface: Colors.grey.shade900,
      ),
      useMaterial3: true,
    );

/// Notifier for theme change
ThemeChangeNotifier get themeChangeNotifier => ThemeChangeNotifier();

/// Current theme mode
ThemeMode get currentThemeMode => themeChangeNotifier.themeMode;

/// Implementation of [ChangeNotifier] that notifies listeners when
/// theme changes
class ThemeChangeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
