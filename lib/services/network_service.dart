import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:devity_console/config/environment.dart';
import 'package:devity_console/exceptions/app_exception.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:dio/dio.dart';

/// Custom options class that extends Dio's Options to include cancelToken
///
/// This class provides additional configuration options for network requests,
/// including the ability to cancel requests in progress.
class NetworkOptions extends Options {
  /// Creates a new instance of NetworkOptions
  ///
  /// [cancelToken] - Optional token to cancel the request
  /// [method] - HTTP method (GET, POST, etc.)
  /// [sendTimeout] - Timeout for sending data
  /// [receiveTimeout] - Timeout for receiving data
  /// [extra] - Additional request options
  /// [headers] - HTTP headers
  /// [responseType] - Expected response type
  /// [contentType] - Content type of the request
  /// [validateStatus] - Function to validate response status
  /// [receiveDataWhenStatusError] - Whether to receive data on error status
  /// [followRedirects] - Whether to follow redirects
  /// [maxRedirects] - Maximum number of redirects to follow
  /// [requestEncoder] - Custom request encoder
  /// [responseDecoder] - Custom response decoder
  /// [listFormat] - Format for list parameters
  NetworkOptions({
    this.cancelToken,
    super.method,
    super.sendTimeout,
    super.receiveTimeout,
    super.extra,
    super.headers,
    super.responseType,
    super.contentType,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
  });

  /// Token used to cancel the request
  final CancelToken? cancelToken;
}

/// A comprehensive network service that handles all API communications
///
/// This service provides a robust implementation for making HTTP requests with
/// features like caching, retry mechanism, debouncing, and error handling.
///
/// Example usage:
/// ```dart
/// final networkService = NetworkService(errorHandler: errorHandler);
/// final response = await networkService.get(
///   '/endpoint',
///   useCache: true,
///   cacheDuration: Duration(minutes: 5),
/// );
/// ```
class NetworkService {
  /// Creates a new instance of NetworkService
  ///
  /// [errorHandler] - Service for handling errors and exceptions
  NetworkService({
    required ErrorHandlerService errorHandler,
  }) : _errorHandler = errorHandler {
    _initDio();
    _initConnectivity();
  }

  /// Service for handling errors and exceptions
  final ErrorHandlerService _errorHandler;

  /// Dio instance for making HTTP requests
  late final Dio _dio;

  /// Connectivity instance for monitoring network status
  final _connectivity = Connectivity();

  /// Cache for storing API responses
  ///
  /// The cache uses a map where the key is a combination of the request method,
  /// path, and query parameters, and the value is a CacheEntry containing the
  /// response data and expiry time.
  final _cache = <String, CacheEntry>{};

  /// Timers for debouncing requests
  ///
  /// This map stores timers for each debounced request, allowing cancellation
  /// of pending requests when new ones are made.
  final _debounceTimers = <String, Timer>{};

  /// Initializes the Dio instance with default configuration
  ///
  /// Sets up:
  /// - Base URL from environment
  /// - Timeout configurations
  /// - Default headers
  /// - Interceptors for caching, retry, and error handling
  void _initDio() {
    print("NETWORK SERVICE: Initializing Dio...");
    print("NETWORK SERVICE: Using base URL: ${Environment.apiBaseUrl}");
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Version': Environment.apiVersion,
          'X-App-Version': Environment.appVersion,
        },
      ),
    );

    // Temporarily comment out interceptors for web debugging
    /*
    _dio.interceptors.addAll([
      _getCacheInterceptor(),
      _getRetryInterceptor(),
      _getErrorInterceptor(),
    ]);
    */
    print("NETWORK SERVICE: INTERCEPTORS TEMPORARILY DISABLED FOR DEBUGGING");
  }

  /// Initializes network connectivity monitoring
  ///
  /// Listens for connectivity changes and handles offline/online transitions.
  /// When offline, it triggers error handling for network-related issues.
  void _initConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _errorHandler.handleError(
          NetworkException(
            message: 'No internet connection available',
            stackTrace: StackTrace.current,
          ),
        );
      }
    });
  }

  /// Creates and returns a cache interceptor
  ///
  /// The interceptor handles:
  /// - Checking cache for existing responses
  /// - Storing responses in cache
  /// - Managing cache expiration
  ///
  /// Returns an Interceptor instance configured for caching
  Interceptor _getCacheInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.extra['useCache'] == true) {
          final cacheKey = _getCacheKey(options);
          final cacheEntry = _cache[cacheKey];

          if (cacheEntry != null && !cacheEntry.isExpired) {
            return handler.resolve(
              Response(
                requestOptions: options,
                data: cacheEntry.data,
                statusCode: 200,
              ),
            );
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.requestOptions.extra['useCache'] == true) {
          final cacheKey = _getCacheKey(response.requestOptions);
          final cacheDuration =
              response.requestOptions.extra['cacheDuration'] as Duration?;

          _cache[cacheKey] = CacheEntry(
            data: response.data,
            expiryTime: DateTime.now().add(
              cacheDuration ?? const Duration(minutes: 5),
            ),
          );
        }
        return handler.next(response);
      },
    );
  }

  /// Creates and returns a retry interceptor
  ///
  /// The interceptor handles:
  /// - Automatic retry for failed requests
  /// - Configurable retry count
  /// - Exponential backoff delay
  /// - Network error detection
  ///
  /// Returns an Interceptor instance configured for retry logic
  Interceptor _getRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.connectionError) {
          final options = error.requestOptions;
          final retryCount = options.extra['retryCount'] as int? ?? 0;
          final maxRetries = options.extra['maxRetries'] as int? ?? 3;

          if (retryCount < maxRetries) {
            options.extra['retryCount'] = retryCount + 1;
            await Future.delayed(
              Duration(seconds: 1 * (retryCount + 1)),
            );
            return handler.resolve(await _dio.fetch(options));
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Creates and returns an error interceptor
  ///
  /// The interceptor handles:
  /// - Converting Dio errors to application exceptions
  /// - Logging errors
  /// - Providing user-friendly error messages
  ///
  /// Returns an Interceptor instance configured for error handling
  Interceptor _getErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final appException = _handleDioError(error);
        _errorHandler.handleError(appException);
        return handler.next(error);
      },
    );
  }

  /// Generates a unique cache key for a request
  ///
  /// The key is based on:
  /// - HTTP method
  /// - Request path
  /// - Query parameters
  ///
  /// [options] - The request options
  /// Returns a string representing the cache key
  String _getCacheKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.queryParameters}';
  }

  /// Converts Dio errors to application-specific exceptions
  ///
  /// Handles various types of network and server errors:
  /// - Connection timeouts
  /// - Response timeouts
  /// - Bad responses
  /// - Cancelled requests
  /// - Unknown errors
  /// - Bad certificates
  /// - Connection errors
  ///
  /// [error] - The Dio error to handle
  /// Returns an AppException instance
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

  /// Handles specific HTTP response errors
  ///
  /// Converts HTTP status codes to appropriate exceptions:
  /// - 400: Validation errors
  /// - 401: Authentication errors
  /// - 403: Authorization errors
  /// - 404: Resource not found
  /// - 500: Server errors
  ///
  /// [error] - The Dio error containing the response
  /// Returns an AppException instance
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
          message: message ?? 'Internal server error. Please try again later.',
          stackTrace: error.stackTrace,
        );
      default:
        return ServerException(
          message: message ?? 'An unexpected error occurred.',
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Make a request with debouncing
  Future<Response> request(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool useCache = false,
    Duration? cacheDuration,
    int maxRetries = 3,
    Duration debounceDuration = const Duration(milliseconds: 500),
  }) async {
    final key = '$method:$path:$queryParameters';
    final timer = _debounceTimers[key];

    if (timer != null) {
      timer.cancel();
    }

    final completer = Completer<Response>();

    _debounceTimers[key] = Timer(debounceDuration, () async {
      try {
        final response = await _dio.request(
          path,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            method: method,
            headers: headers,
            extra: {
              'useCache': useCache,
              'cacheDuration': cacheDuration,
              'maxRetries': maxRetries,
            },
          ),
        );
        completer.complete(response);
      } catch (e) {
        completer.completeError(e);
      } finally {
        _debounceTimers.remove(key);
      }
    });

    return completer.future;
  }

  /// Clear cache for specific URL
  void clearCacheForUrl(String url) {
    _cache.removeWhere((key, _) => key.contains(url));
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
  }

  /// Dispose the service
  void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    _cache.clear();
  }
}

/// Cache entry class
class CacheEntry {
  /// Constructor
  CacheEntry({
    required this.data,
    required this.expiryTime,
  });

  /// Cached data
  final dynamic data;

  /// Expiry time
  final DateTime expiryTime;

  /// Check if cache entry is expired
  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
