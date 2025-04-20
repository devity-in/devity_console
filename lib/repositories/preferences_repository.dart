import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final mode = _prefs.getString(_themeModeKey);
    if (mode == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == mode,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(
        _localeKey,
        jsonEncode({
          'languageCode': locale.languageCode,
          'countryCode': locale.countryCode,
        }));
  }

  Future<Locale> getLocale() async {
    final localeJson = _prefs.getString(_localeKey);
    if (localeJson == null) return const Locale('en');

    try {
      final data = jsonDecode(localeJson) as Map<String, dynamic>;
      return Locale(
        data['languageCode'] as String,
        data['countryCode'] as String?,
      );
    } catch (e) {
      return const Locale('en');
    }
  }
}
