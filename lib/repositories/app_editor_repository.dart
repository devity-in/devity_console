import 'package:devity_console/services/app_editor_service.dart';
import 'package:devity_console/services/cache_service.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';

/// Repository for handling app editor data
class AppEditorRepository {
  AppEditorRepository({
    AppEditorService? service,
    ErrorHandlerService? errorHandler,
    NetworkService? networkService,
    CacheService? cacheService,
  })  : _service = service ?? AppEditorService(),
        _errorHandler = errorHandler ?? ErrorHandlerService(),
        _networkService = networkService ??
            NetworkService(errorHandler: ErrorHandlerService()),
        _cacheService = cacheService ?? CacheService.instance;

  final AppEditorService _service;
  final ErrorHandlerService _errorHandler;
  final NetworkService _networkService;
  final CacheService _cacheService;
  static const String _pagesKey = 'app_pages';
  static const String _editorStateKey = 'editor_state';

  /// Saves the current state of the editor
  Future<void> saveEditorState({
    required String projectId,
    required Map<String, dynamic> state,
  }) async {
    try {
      await _networkService.request(
        '/projects/$projectId/editor-state',
        method: 'POST',
        data: state,
      );

      // Cache the state
      await _cacheService.cacheData('$_editorStateKey:$projectId', state);
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Loads the editor state
  Future<Map<String, dynamic>> loadEditorState(String projectId) async {
    try {
      // Try to load from cache first
      final cachedState =
          await _cacheService.getCachedData('$_editorStateKey:$projectId');
      if (cachedState != null) {
        return cachedState as Map<String, dynamic>;
      }

      // If not in cache, load from API
      final response = await _networkService.request(
        '/projects/$projectId/editor-state',
        useCache: true,
      );
      final state = response.data as Map<String, dynamic>;

      // Cache the state
      await _cacheService.cacheData('$_editorStateKey:$projectId', state);

      return state;
    } catch (e) {
      // If API fails, return cached data if available
      final cachedState =
          await _cacheService.getCachedData('$_editorStateKey:$projectId');
      if (cachedState != null) {
        return cachedState as Map<String, dynamic>;
      }
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Clears the cache for a project
  void clearProjectCache(String projectId) {
    _cacheService.clearCache('$_pagesKey:$projectId');
    _cacheService.clearCache('$_editorStateKey:$projectId');
  }

  /// Disposes the repository
  void dispose() {
    // No cleanup needed
  }
}
