import 'package:devity_console/services/error_handler_service.dart';
import 'package:flutter/material.dart';

/// A widget that catches and handles errors in its child widget tree.
///
/// This widget implements an error boundary pattern similar to React's error boundaries.
/// It catches errors that occur in its child widget tree and displays a fallback UI
/// instead of crashing the app.
///
/// # Architecture Overview
///
/// The ErrorBoundary widget works in conjunction with several services:
/// - ErrorHandlerService: Handles different types of errors and provides user-friendly messages
/// - LoggerService: Logs errors for debugging and monitoring
/// - AppException: Base exception class for custom application errors
///
/// The error handling flow:
/// 1. An error occurs in the child widget tree
/// 2. ErrorBoundary catches the error and stack trace
/// 3. ErrorHandlerService processes the error and returns a user-friendly message
/// 4. LoggerService logs the error for debugging
/// 5. A fallback UI is displayed with the error message and a retry button
///
/// # Setup Instructions
///
/// 1. Wrap your app or specific widget trees with ErrorBoundary:
/// ```dart
/// ErrorBoundary(
///   child: MyApp(),
///   onError: (error, stackTrace) {
///     // Optional: Handle errors globally
///     LoggerService.commonLog('App error', error: error, stackTrace: stackTrace);
///   },
/// )
/// ```
///
/// 2. For specific error handling, wrap individual widgets:
/// ```dart
/// ErrorBoundary(
///   child: MyComplexWidget(),
///   onError: (error, stackTrace) {
///     // Handle errors specific to this widget
///   },
/// )
/// ```
///
/// # API Documentation
///
/// ## Properties
///
/// - `child` (required): The widget below this widget in the tree
/// - `onError` (optional): Callback called when an error occurs
///
/// ## Error Types Handled
///
/// The ErrorBoundary handles various types of errors:
/// - AppException: Custom application errors
/// - DioException: Network and API errors
/// - Generic errors: Any other unhandled exceptions
///
/// ## Error UI
///
/// When an error occurs, the widget displays:
/// - An error icon
/// - A user-friendly error message
/// - A "Try Again" button to reset the error state
///
/// ## Error Recovery
///
/// Users can recover from errors by:
/// 1. Clicking the "Try Again" button
/// 2. The widget resets its error state
/// 3. The child widget tree is rebuilt
class ErrorBoundary extends StatefulWidget {
  /// Creates an error boundary
  const ErrorBoundary({
    required this.child,
    this.onError,
    super.key,
  });

  /// The widget below this widget in the tree
  final Widget child;

  /// Callback called when an error occurs
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  final _errorHandler = ErrorHandlerService();
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorWidget();
    }
    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _errorHandler.handleError(_error!, _stackTrace),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetError,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _resetError() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack);
    };
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });

    widget.onError?.call(error, stackTrace ?? StackTrace.current);
  }
}
