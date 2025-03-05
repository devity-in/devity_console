import 'package:flutter/material.dart';

/// Light theme data
ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      useMaterial3: true,
    );

/// Dark theme data
ThemeData get darkTheme => ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
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
