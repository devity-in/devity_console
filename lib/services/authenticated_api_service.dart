import 'package:devity_console/config/constants.dart';
import 'package:devity_console/exceptions/app_exception.dart';
import 'package:devity_console/models/token_response.dart';
import 'package:devity_console/services/error_handler_service.dart';
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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    // Adding interceptors
    _dio.interceptors.addAll([
      _getRequestInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: print,
      ),
    ]);
  }

  // Dio instance
  late Dio _dio;

  /// Base URL of your API
  final String baseUrl = Constants.baseUrl;

  /// Token storage service
  final _tokenStorageService = TokenStorageService();

  /// Error handler service
  final _errorHandler = ErrorHandlerService();

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
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleGenericError(e, stackTrace);
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
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleGenericError(e, stackTrace);
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
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleGenericError(e, stackTrace);
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
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleGenericError(e, stackTrace);
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
        throw const TokenException(message: 'No token available to refresh');
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
}
