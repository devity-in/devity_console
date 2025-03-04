import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      useMaterial3: true,
    );

ThemeData get darkTheme => ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      useMaterial3: true,
    );

ThemeChangeNotifier get themeChangeNotifier => ThemeChangeNotifier();

ThemeMode get currentThemeMode => themeChangeNotifier.themeMode;

class ThemeChangeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
