import 'package:devity_console/services/app_editor_service.dart';
import 'package:devity_console/services/cache_service.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';

/// Repository for handling app editor data
class SpecEditorRepository {
  SpecEditorRepository({
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

  /// Fetches the main spec content for a given project.
  /// Returns the parsed JSON content as a map, or null if not found.
  Future<Map<String, dynamic>?> getSpecForProject(String projectId) async {
    // TODO: How to determine the primary spec ID (UUID) for a projectId?
    // Option 1: Have a dedicated backend endpoint GET /projects/{projectId}/spec
    // Option 2: Assume a naming convention or lookup mechanism.
    // For now, this is a placeholder.
    print(
      'Placeholder: SpecEditorRepository.getSpecForProject called for $projectId',
    );
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate spec not found (e.g., for a new project)
    // In a real scenario, call _networkService.request('/specs/{spec_id}')
    // and handle potential 404 errors from the backend.
    return null;
    // Example for returning found data:
    // try {
    //   final response = await _networkService.request('/specs/{the_spec_id}');
    //   return response.data as Map<String, dynamic>;
    // } catch (e) {
    //    // Handle network errors or 404s specifically
    //    if (e is DioException && e.response?.statusCode == 404) {
    //      return null; // Spec not found
    //    }
    //   _errorHandler.handleError(e);
    //   rethrow; // Or return null / throw specific exception
    // }
  }

  /// Saves the spec data to the backend.
  /// Uses PUT if specIdUUID is provided, otherwise POST.
  Future<void> saveSpec({
    required String projectId,
    required Map<String, dynamic> specData,
    String? specIdUUID, // The database primary key (UUID as String)
  }) async {
    // TODO: Refine API endpoint strategy (e.g., dedicated project endpoint?)
    String url;
    String method;

    final requestData = Map<String, dynamic>.from(specData);
    // Ensure project_id is in the data being sent, if required by backend schema
    if (!requestData.containsKey('project_id') ||
        requestData['project_id'] == null) {
      requestData['project_id'] = projectId;
      // This assumes project_id is a simple string in the console context
      // but the backend schema expects a UUID. Requires conversion or schema alignment.
      print(
          'Warning: Added projectId to specData for saving. Ensure backend schema alignment (String vs UUID).');
      // If backend expects UUID: requestData['project_id'] = Uuid.parse(projectId); ?
    }

    if (specIdUUID != null) {
      // Existing spec, use PUT to update
      url = '/specs/$specIdUUID';
      method = 'PUT';
      print('Saving spec via PUT to $url');
    } else {
      // New spec, use POST to create
      url = '/specs/';
      method = 'POST';
      print('Saving new spec via POST to $url');
      // Backend will generate the UUID id upon creation
    }

    try {
      final response = await _networkService.request(
        url,
        method: method,
        data: requestData,
      );
      print('Save response: ${response.statusCode}');
      // TODO: Handle response? Update local state with returned ID/data?
      // If POST was used, the response body might contain the newly created spec with its UUID.
      // We might want to update the Bloc state with this new data (especially the UUID).
    } catch (e) {
      _errorHandler.handleError(e);
      rethrow;
    }
  }

  /// Disposes the repository
  void dispose() {
    // No cleanup needed
  }
}
