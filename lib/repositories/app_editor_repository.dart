import 'package:devity_console/models/app_page.dart';
import 'package:devity_console/services/app_editor_service.dart';
import 'package:devity_console/services/error_handler_service.dart';

/// Repository for handling app editor data
class AppEditorRepository {
  /// Creates a new [AppEditorRepository]
  AppEditorRepository({
    AppEditorService? service,
    ErrorHandlerService? errorHandler,
  })  : _service = service ?? AppEditorService(),
        _errorHandler = errorHandler ?? ErrorHandlerService();

  final AppEditorService _service;
  final ErrorHandlerService _errorHandler;

  /// Loads all pages for a project
  Future<List<AppPage>> loadPages(String projectId) async {
    try {
      return await _service.loadPages(projectId);
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
      return await _service.createPage(
        projectId: projectId,
        name: name,
        description: description,
      );
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
      return await _service.updatePage(
        projectId: projectId,
        pageId: pageId,
        name: name,
        description: description,
      );
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
      await _service.deletePage(
        projectId: projectId,
        pageId: pageId,
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
      await _service.saveEditorState(
        projectId: projectId,
        state: state,
      );
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Loads the editor state
  Future<Map<String, dynamic>> loadEditorState(String projectId) async {
    try {
      return await _service.loadEditorState(projectId);
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Clears the cache for a project
  void clearProjectCache(String projectId) {
    _service.clearProjectCache(projectId);
  }

  /// Disposes the repository
  void dispose() {
    _service.dispose();
  }
}
