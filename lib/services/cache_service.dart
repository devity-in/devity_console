import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching data locally
class CacheService {
  /// Private constructor
  CacheService._();

  /// Static instance
  static final CacheService _instance = CacheService._();

  /// Get the singleton instance
  static CacheService get instance => _instance;

  /// Shared preferences instance
  SharedPreferences? _sharedPreferences;

  /// Whether the service is initialized
  bool get isInitialized => _sharedPreferences != null;

  /// Initializes the cache service
  Future<void> init() async {
    if (!isInitialized) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  /// Ensures the service is initialized
  Future<void> _ensureInitialized() async {
    if (!isInitialized) {
      await init();
    }
  }

  /// Caches data with a specific key
  Future<void> cacheData(String key, dynamic data) async {
    await _ensureInitialized();
    await _sharedPreferences!.setString(key, json.encode(data));
  }

  /// Retrieves cached data
  Future<dynamic> getCachedData(String key) async {
    await _ensureInitialized();
    final jsonStr = _sharedPreferences!.getString(key);
    if (jsonStr == null) return null;
    return json.decode(jsonStr);
  }

  /// Clears cached data for a specific key
  Future<void> clearCache(String key) async {
    await _ensureInitialized();
    await _sharedPreferences!.remove(key);
  }

  /// Clears all cached data
  Future<void> clearAllCache() async {
    await _ensureInitialized();
    await _sharedPreferences!.clear();
  }
}
