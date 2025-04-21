import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  PreferencesRepository(this._prefs);
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  final Future<SharedPreferences> _prefs;

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _prefs;
    await prefs.setString(_themeModeKey, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await _prefs;
    final mode = prefs.getString(_themeModeKey);
    if (mode == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == mode,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await _prefs;
    await prefs.setString(
      _localeKey,
      jsonEncode({
        'languageCode': locale.languageCode,
        'countryCode': locale.countryCode,
      }),
    );
  }

  Future<Locale> getLocale() async {
    final prefs = await _prefs;
    final localeJson = prefs.getString(_localeKey);
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
