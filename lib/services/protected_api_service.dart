import 'package:devity_console/config/environment.dart';
import 'package:devity_console/exceptions/app_exception.dart';
import 'package:devity_console/models/token_response.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:devity_console/services/token_storage_service.dart';
import 'package:dio/dio.dart';

/// API Service for protected endpoints
class ProtectedApiService {
  /// Constructor
  ProtectedApiService({
    required NetworkService networkService,
    required TokenStorageService tokenStorage,
  })  : _networkService = networkService,
        _tokenStorage = tokenStorage;

  // Network service instance
  final NetworkService _networkService;

  /// Token storage service
  final TokenStorageService _tokenStorage;

  /// Error handler service
  final _errorHandler = ErrorHandlerService();

  /// GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool useCache = false,
    Duration? cacheDuration,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    return _networkService.request(
      '${Environment.apiBaseUrl}$path',
      queryParameters: queryParameters,
      useCache: useCache,
      cacheDuration: cacheDuration,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    return _networkService.request(
      '${Environment.apiBaseUrl}$path',
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    return _networkService.request(
      '${Environment.apiBaseUrl}$path',
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// DELETE Request
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    return _networkService.request(
      '${Environment.apiBaseUrl}$path',
      method: 'DELETE',
      queryParameters: queryParameters,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// PATCH Request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }

    return _networkService.request(
      '${Environment.apiBaseUrl}$path',
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Refresh the access token
  Future<bool> _refreshToken() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) {
        throw const TokenException(message: 'No token available to refresh');
      }

      // Check if token is about to expire (within 5 minutes)
      if (!token.willExpireIn(const Duration(minutes: 5))) {
        return true;
      }

      final response = await _networkService.request(
        '/refresh',
        method: 'POST',
        data: {
          'refreshToken': token.refreshToken,
        },
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final newToken =
            TokenResponse.fromJson(response.data as Map<String, dynamic>);
        await _tokenStorage.saveToken(newToken);
        return true;
      }
      throw const TokenException(message: 'Failed to refresh token');
    } catch (e, stackTrace) {
      throw _handleGenericError(e, stackTrace);
    }
  }

  /// Handle Dio errors
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        return _handleDioResponseError(error);
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled.',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          message: 'Network error. Please check your internet connection.',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Invalid certificate. Please contact support.',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection error. Please check your internet connection.',
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Handle Dio response errors
  AppException _handleDioResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['message'] as String?;

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message ?? 'Invalid request. Please try again.',
          stackTrace: error.stackTrace,
        );
      case 401:
        return AuthenticationException(
          message: message ?? 'Session expired. Please log in again.',
          stackTrace: error.stackTrace,
        );
      case 403:
        return AuthorizationException(
          message: message ?? 'Access denied. Please contact support.',
          stackTrace: error.stackTrace,
        );
      case 404:
        return ServerException(
          message: message ?? 'Resource not found.',
          stackTrace: error.stackTrace,
        );
      case 500:
        return ServerException(
          message: message ?? 'Server error. Please try again later.',
          stackTrace: error.stackTrace,
        );
      default:
        return ServerException(
          message: message ?? 'An error occurred. Please try again later.',
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Handle generic errors
  AppException _handleGenericError(Object error, StackTrace stackTrace) {
    if (error is AppException) {
      return error;
    }
    return ServerException(
      message: 'An unexpected error occurred. Please try again later.',
      stackTrace: stackTrace,
    );
  }

  /// Clear cache for specific endpoint
  void clearCacheForEndpoint(String endpoint) {
    _networkService.clearCacheForUrl(endpoint);
  }

  /// Clear all cache
  void clearCache() {
    _networkService.clearCache();
  }

  /// Dispose the service
  void dispose() {
    _networkService.dispose();
  }

  /// Get authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      return {'Authorization': 'Bearer ${token.accessToken}'};
    }
    return {};
  }
}
