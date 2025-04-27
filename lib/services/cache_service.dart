import 'dart:convert';

import 'package:devity_console/models/app_page.dart';
import 'package:devity_console/models/custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching data locally
class CacheService {
  /// Creates a new [CacheService]
  CacheService({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;
  static const String _pagesKey = 'app_pages';
  static const String _editorStateKey = 'editor_state';

  /// Initializes the cache service
  Future<void> init() async {}

  /// Caches a list of pages
  Future<void> cachePages(String projectId, List<AppPage> pages) async {
    final key = '$_pagesKey:$projectId';
    final jsonPages = pages.map((page) => page.toJson()).toList();
    await sharedPreferences.setString(key, json.encode(jsonPages));
  }

  /// Retrieves cached pages
  Future<List<AppPage>> getCachedPages(String projectId) async {
    final key = '$_pagesKey:$projectId';
    final jsonStr = sharedPreferences.getString(key);
    if (jsonStr == null) return [];

    final jsonList = json.decode(jsonStr) as List;
    return jsonList
        .map((json) => AppPage.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Caches the editor state
  Future<void> cacheEditorState(
    String projectId,
    Map<String, dynamic> state,
  ) async {
    final key = '$_editorStateKey:$projectId';
    await sharedPreferences.setString(key, json.encode(state));
  }

  /// Retrieves the cached editor state
  Future<Map<String, dynamic>?> getCachedEditorState(String projectId) async {
    final key = '$_editorStateKey:$projectId';
    final jsonStr = sharedPreferences.getString(key);
    if (jsonStr == null) return null;

    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  /// Clears all cached data for a project
  Future<void> clearProjectCache(String projectId) async {
    final pagesKey = '$_pagesKey:$projectId';
    final stateKey = '$_editorStateKey:$projectId';
    await sharedPreferences.remove(pagesKey);
    await sharedPreferences.remove(stateKey);
  }

  /// Clears all cached data
  Future<void> clearAllCache() async {
    await sharedPreferences.clear();
  }

  /// Gets cached custom widgets for a project
  Future<List<CustomWidget>> getCachedCustomWidgets(String projectId) async {
    final json = sharedPreferences.getString('custom_widgets_$projectId');
    if (json == null) return [];
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((w) => CustomWidget.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  /// Caches custom widgets for a project
  Future<void> cacheCustomWidgets(
    String projectId,
    List<CustomWidget> widgets,
  ) async {
    final json = jsonEncode(widgets.map((w) => w.toJson()).toList());
    await sharedPreferences.setString('custom_widgets_$projectId', json);
  }
}
