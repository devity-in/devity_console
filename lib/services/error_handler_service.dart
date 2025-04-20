import 'package:devity_console/exceptions/app_exception.dart';
import 'package:devity_console/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Service for handling errors across the application
class ErrorHandlerService {
  /// Handle an error and return a user-friendly message
  String handleError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      // Log the error with stack trace
      LoggerService.commonLog(
        'Error: ${error.message}',
        error: error,
        stackTrace: error.stackTrace ?? stackTrace,
        level: 3, // Error level
      );

      // Return user-friendly message
      return error.message;
    }

    // Handle Dio errors
    if (error is DioException) {
      final message = _handleDioError(error);
      LoggerService.commonLog(
        'Dio Error: $message',
        error: error,
        stackTrace: stackTrace,
        level: 3,
      );
      return message;
    }

    // Handle other errors
    LoggerService.commonLog(
      'Unknown Error: $error',
      error: error,
      stackTrace: stackTrace,
      level: 3,
    );
    return 'An unexpected error occurred. Please try again later.';
  }

  /// Show an error snackbar
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle Dio errors
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return _handleDioResponseError(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'Network error. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Invalid certificate. Please contact support.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
    }
  }

  /// Handle Dio response errors
  String _handleDioResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'Access denied. Please contact support.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again later.';
    }
  }
}
