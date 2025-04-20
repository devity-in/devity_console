import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devity_console/exceptions/app_exception.dart';
import 'package:devity_console/config/constants.dart';
import 'package:devity_console/services/error_handler_service.dart';

/// Custom options class that includes cancelToken
class NetworkOptions extends Options {
  NetworkOptions({
    this.cancelToken,
    String? method,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    String? contentType,
    ValidateStatus? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    RequestEncoder? requestEncoder,
    ResponseDecoder? responseDecoder,
    ListFormat? listFormat,
  }) : super(
          method: method,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          extra: extra,
          headers: headers,
          responseType: responseType,
          contentType: contentType,
          validateStatus: validateStatus,
          receiveDataWhenStatusError: receiveDataWhenStatusError,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          requestEncoder: requestEncoder,
          responseDecoder: responseDecoder,
          listFormat: listFormat,
        );

  final CancelToken? cancelToken;
}

/// Network service for handling API requests
class NetworkService {
  /// Constructor
  NetworkService({
    required ErrorHandlerService errorHandler,
  }) : _errorHandler = errorHandler {
    _initDio();
    _initConnectivity();
  }

  /// Error handler service
  final ErrorHandlerService _errorHandler;

  /// Dio instance
  late final Dio _dio;

  /// Connectivity instance
  final _connectivity = Connectivity();

  /// Cache for storing responses
  final _cache = <String, CacheEntry>{};

  /// Debounce timers
  final _debounceTimers = <String, Timer>{};

  /// Initialize Dio with default configuration
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: constants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Version': constants.apiVersion,
          'X-App-Version': constants.appVersion,
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _getCacheInterceptor(),
      _getRetryInterceptor(),
      _getErrorInterceptor(),
    ]);
  }

  /// Initialize connectivity monitoring
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

  /// Get cache interceptor
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

  /// Get retry interceptor
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

  /// Get error interceptor
  Interceptor _getErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final appException = _handleDioError(error);
        _errorHandler.handleError(appException);
        return handler.next(error);
      },
    );
  }

  /// Get cache key for request
  String _getCacheKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.queryParameters}';
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
    final key = '$method:$path:${queryParameters?.toString()}';
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
