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
    try {
      if (!isInitialized) {
        _sharedPreferences = await SharedPreferences.getInstance();
      }
    } catch (e) {
      // Log the error but don't throw
      print('Error initializing CacheService: $e');
      // Set to null to allow retry
      _sharedPreferences = null;
    }
  }

  /// Ensures the service is initialized
  Future<void> _ensureInitialized() async {
    if (!isInitialized) {
      await init();
    }
    if (!isInitialized) {
      throw Exception('Failed to initialize CacheService');
    }
  }

  /// Caches data with a specific key
  Future<void> cacheData(String key, dynamic data) async {
    try {
      await _ensureInitialized();
      await _sharedPreferences!.setString(key, json.encode(data));
    } catch (e) {
      print('Error caching data: $e');
      rethrow;
    }
  }

  /// Retrieves cached data
  Future<dynamic> getCachedData(String key) async {
    try {
      await _ensureInitialized();
      final jsonStr = _sharedPreferences!.getString(key);
      if (jsonStr == null) return null;
      return json.decode(jsonStr);
    } catch (e) {
      print('Error getting cached data: $e');
      rethrow;
    }
  }

  /// Clears cached data for a specific key
  Future<void> clearCache(String key) async {
    try {
      await _ensureInitialized();
      await _sharedPreferences!.remove(key);
    } catch (e) {
      print('Error clearing cache: $e');
      rethrow;
    }
  }

  /// Clears all cached data
  Future<void> clearAllCache() async {
    try {
      await _ensureInitialized();
      await _sharedPreferences!.clear();
    } catch (e) {
      print('Error clearing all cache: $e');
      rethrow;
    }
  }
}
