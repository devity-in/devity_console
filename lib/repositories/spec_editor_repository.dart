import 'dart:convert';

import 'package:devity_console/services/app_editor_service.dart';
import 'package:devity_console/services/cache_service.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/logger_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:http/http.dart' as http;

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
        return Map<String, dynamic>.from(cachedState as Map);
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
        return Map<String, dynamic>.from(cachedState as Map);
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

  // --- Spec Loading/Saving Methods ---

  // TODO: Replace with actual API endpoint from config/env
  final String _baseUrl =
      'http://127.0.0.1:8000'; // Assuming backend runs locally

  // Helper function to deeply cast maps
  Map<String, dynamic> _deepCastStringDynamicMap(Map originalMap) {
    final newMap = <String, dynamic>{};
    originalMap.forEach((key, value) {
      final stringKey = key.toString(); // Ensure key is a string
      if (value is Map) {
        newMap[stringKey] = _deepCastStringDynamicMap(value);
      } else if (value is List) {
        newMap[stringKey] = _deepCastList(value);
      } else {
        newMap[stringKey] = value;
      }
    });
    return newMap;
  }

  List<dynamic> _deepCastList(List originalList) {
    final newList = <dynamic>[];
    for (final item in originalList) {
      if (item is Map) {
        newList.add(_deepCastStringDynamicMap(item));
      } else if (item is List) {
        newList.add(_deepCastList(item));
      } else {
        newList.add(item);
      }
    }
    return newList;
  }

  /// Fetches the main spec content for a given project.
  /// Returns the parsed JSON content as a map, or a default structure if not found.
  Future<Map<String, dynamic>> getSpecForProject(String projectId) async {
    // Assume projectId directly maps to the spec UUID/ID for the API call
    final url = Uri.parse('$_baseUrl/specs/$projectId');
    try {
      LoggerService.commonLog(
        'Attempting to fetch spec from $url',
        name: 'SpecEditorRepository.getSpecForProject',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        LoggerService.commonLog(
          'Spec fetched successfully for $projectId',
          name: 'SpecEditorRepository.getSpecForProject',
        );
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseBody.containsKey('content') &&
            responseBody['content'] is Map) {
          // Explicitly cast the content to the expected type using the helper
          return _deepCastStringDynamicMap(responseBody['content'] as Map);
        } else {
          LoggerService.commonLog(
            'Warning: Spec content not found or not a map in response for $projectId. Returning default.',
            name: 'SpecEditorRepository.getSpecForProject',
          );
          return _defaultSpec();
        }
      } else if (response.statusCode == 404) {
        LoggerService.commonLog(
          'Spec not found for project $projectId (404). Returning default.',
          name: 'SpecEditorRepository.getSpecForProject',
        );
        return _defaultSpec();
      } else {
        LoggerService.commonLog(
          'Failed to load spec: ${response.statusCode} ${response.body}',
          name: 'SpecEditorRepository.getSpecForProject',
        );
        throw Exception('Failed to load spec: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerService.commonLog(
        'Error fetching spec: $e',
        name: 'SpecEditorRepository.getSpecForProject',
        error: e,
        stackTrace: stackTrace,
      );
      // Depending on requirements, might return default spec or rethrow
      // return _defaultSpec();
      throw Exception('Error fetching spec: $e');
    }
  }

  /// Saves the spec data to the backend.
  /// Attempts PUT first, then POST if PUT fails with 404.
  Future<void> saveSpec(String projectId, Map<String, dynamic> specData) async {
    // Assume projectId maps to spec ID.
    final url = Uri.parse('$_baseUrl/specs/$projectId');
    final postUrl = Uri.parse('$_baseUrl/specs');

    try {
      // The backend expects the spec data within a 'content' field,
      // and also requires top-level 'id', 'name', and 'version'.
      final body = jsonEncode({
        'id': projectId, // Assuming projectId is the UUID
        'name': 'Project Spec $projectId', // Placeholder name
        'version': '1.0.0', // Placeholder version
        'content': specData, // The actual spec tree goes here
      });

      LoggerService.commonLog(
        'Attempting to save spec via PUT to $url',
        name: 'SpecEditorRepository.saveSpec',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        LoggerService.commonLog(
          'Spec saved successfully (PUT) for project $projectId',
          name: 'SpecEditorRepository.saveSpec',
        );
        // Potentially clear cache or update state if needed
      } else if (response.statusCode == 404) {
        LoggerService.commonLog(
          'Spec not found for PUT (404), trying POST to $postUrl',
          name: 'SpecEditorRepository.saveSpec',
        );
        // If PUT fails with 404, it might mean we need to POST (create)
        final postResponse = await http.post(
          postUrl,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        if (postResponse.statusCode == 200 || postResponse.statusCode == 201) {
          LoggerService.commonLog(
            'Spec created successfully (POST) for project $projectId',
            name: 'SpecEditorRepository.saveSpec',
          );
        } else {
          LoggerService.commonLog(
            'Failed to create spec (POST): ${postResponse.statusCode} ${postResponse.body}',
            name: 'SpecEditorRepository.saveSpec',
          );
          throw Exception('Failed to create spec: ${postResponse.statusCode}');
        }
      } else {
        LoggerService.commonLog(
          'Failed to save spec (PUT): ${response.statusCode} ${response.body}',
          name: 'SpecEditorRepository.saveSpec',
        );
        throw Exception('Failed to save spec: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerService.commonLog(
        'Error saving spec: $e',
        name: 'SpecEditorRepository.saveSpec',
        error: e,
        stackTrace: stackTrace,
      );
      // Rethrow or handle
      throw Exception('Error saving spec: $e');
    }
  }

  // Helper to return a default spec structure
  Map<String, dynamic> _defaultSpec() {
    return {
      'id': 'root', // Default root ID
      'type': 'Container', // Default root type
      'children': [],
    };
  }
}
