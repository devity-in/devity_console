import 'package:devity_console/services/error_handler_service.dart';
import 'package:flutter/material.dart';

/// A widget that catches and handles errors in its child widget tree
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
