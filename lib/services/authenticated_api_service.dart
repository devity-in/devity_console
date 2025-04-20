import 'package:devity_console/config/constants.dart';
import 'package:devity_console/models/token_response.dart';
import 'package:devity_console/services/token_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// API Service
class AuthenticatedApiService {
  /// Constructor
  AuthenticatedApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout:
            const Duration(seconds: 10), // Updated timeout with Duration
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    // Adding interceptors
    _dio.interceptors.addAll([
      _getRequestInterceptor(), // Custom Interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: print, // Updated logging in Dio 5.x
      ),
    ]);
  }
  // Dio instance
  late Dio _dio;

  /// Base URL of your API
  final String baseUrl = Constants.baseUrl;

  /// Token storage service
  final _tokenStorageService = TokenStorageService();

  /// GET Request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response;
      response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the request with new token
          return get(endpoint,
              queryParams: queryParams, cancelToken: cancelToken);
        }
      }
      final errorMessage = _handleError(e);
      debugPrint('DioException: $errorMessage');
      rethrow;
    }
  }

  /// POST Request
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response;
      response = await _dio.post(
        endpoint,
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the request with new token
          return post(endpoint, data: data, cancelToken: cancelToken);
        }
      }
      final errorMessage = _handleError(e);
      debugPrint('DioException: $errorMessage');
      rethrow;
    }
  }

  /// PUT Request
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response;
      response = await _dio.put(
        endpoint,
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the request with new token
          return put(endpoint, data: data, cancelToken: cancelToken);
        }
      }
      final errorMessage = _handleError(e);
      debugPrint('DioException: $errorMessage');
      rethrow;
    }
  }

  /// DELETE Request
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response;
      response = await _dio.delete(
        endpoint,
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the request with new token
          return delete(endpoint, data: data, cancelToken: cancelToken);
        }
      }
      final errorMessage = _handleError(e);
      debugPrint('DioException: $errorMessage');
      rethrow;
    }
  }

  /// Cancel Token for canceling requests
  CancelToken getCancelToken() {
    return CancelToken();
  }

  /// Refresh the access token
  Future<bool> _refreshToken() async {
    try {
      final token = await _tokenStorageService.getToken();
      if (token == null) {
        return false;
      }

      // Check if token is about to expire (within 5 minutes)
      if (!token.willExpireIn(const Duration(minutes: 5))) {
        return true;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {
          'refreshToken': token.refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final newToken =
            TokenResponse.fromJson(response.data as Map<String, dynamic>);
        await _tokenStorageService.saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  // Interceptor for modifying requests
  Interceptor _getRequestInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint('Error occurred: ${error.message}');
        return handler.next(error);
      },
    );
  }

  // Error handling
  String _handleError(DioException error) {
    var errorDescription = 'Unknown error occurred';
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = 'Request to API was canceled';
      case DioExceptionType.connectionTimeout:
        errorDescription = 'Connection timeout with API server';
      case DioExceptionType.receiveTimeout:
        errorDescription = 'Receive timeout in connection with API server';
      case DioExceptionType.badResponse:
        errorDescription = _handleServerError(error.response?.statusCode);
      case DioExceptionType.sendTimeout:
        errorDescription = 'Send timeout in connection with API server';
      case DioExceptionType.unknown:
        errorDescription =
            'Connection to API server failed due to internet connection';
      case DioExceptionType.badCertificate:
        errorDescription = 'Bad certificate';
      case DioExceptionType.connectionError:
        errorDescription = 'Connection error';
    }

    return errorDescription;
  }

  // Custom Error Handling for Server Responses
  String _handleServerError(int? statusCode) {
    if (statusCode == null) return 'Unknown error occurred';
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Received invalid status code: $statusCode';
    }
  }
}
