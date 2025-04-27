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
