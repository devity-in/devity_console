import 'package:devity_console/models/app_page.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';

/// Service for handling app editor API calls
class AppEditorService {
  /// Creates a new [AppEditorService]
  AppEditorService({
    NetworkService? networkService,
    ErrorHandlerService? errorHandler,
  })  : _networkService = networkService ??
            NetworkService(errorHandler: ErrorHandlerService()),
        _errorHandler = errorHandler ?? ErrorHandlerService();

  final NetworkService _networkService;
  final ErrorHandlerService _errorHandler;

  /// Loads all pages for a project
  Future<List<AppPage>> loadPages(String projectId) async {
    try {
      final response = await _networkService.request(
        '/projects/$projectId/pages',
        useCache: true,
        cacheDuration: const Duration(minutes: 5),
      );

      return (response.data['pages'] as List)
          .map((page) => AppPage.fromJson(page as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Creates a new page
  Future<AppPage> createPage({
    required String projectId,
    required String name,
    required String description,
  }) async {
    try {
      final response = await _networkService.request(
        '/projects/$projectId/pages',
        method: 'POST',
        data: {
          'name': name,
          'description': description,
        },
      );

      return AppPage.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Updates an existing page
  Future<AppPage> updatePage({
    required String projectId,
    required String pageId,
    required String name,
    required String description,
  }) async {
    try {
      final response = await _networkService.request(
        '/projects/$projectId/pages/$pageId',
        method: 'PUT',
        data: {
          'name': name,
          'description': description,
        },
      );

      return AppPage.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Deletes a page
  Future<void> deletePage({
    required String projectId,
    required String pageId,
  }) async {
    try {
      await _networkService.request(
        '/projects/$projectId/pages/$pageId',
        method: 'DELETE',
      );
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

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
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Loads the editor state
  Future<Map<String, dynamic>> loadEditorState(String projectId) async {
    try {
      final response = await _networkService.request(
        '/projects/$projectId/editor-state',
        useCache: true,
        cacheDuration: const Duration(minutes: 5),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Clears the cache for a project
  void clearProjectCache(String projectId) {
    _networkService.clearCacheForUrl('/projects/$projectId');
  }

  /// Disposes the service
  void dispose() {
    _networkService.dispose();
  }
}
