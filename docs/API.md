# Devity Console API Documentation

## Overview

This document provides detailed information about the public interfaces and APIs available in the Devity Console application. It covers the core services, their methods, and usage examples.

## Network Service

### NetworkService

The `NetworkService` class provides a comprehensive API for making HTTP requests with built-in features like caching, retry mechanism, and error handling.

#### Constructor

```dart
NetworkService({
  required ErrorHandlerService errorHandler,
})
```

**Parameters:**
- `errorHandler`: Service for handling errors and exceptions

#### Methods

##### GET Request

```dart
Future<Response> get(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
  bool useCache = false,
  Duration? cacheDuration,
})
```

**Parameters:**
- `path`: API endpoint path
- `queryParameters`: Optional query parameters
- `options`: Request options
- `cancelToken`: Token to cancel the request
- `onReceiveProgress`: Progress callback
- `useCache`: Whether to use caching
- `cacheDuration`: Duration for cache validity

**Returns:**
- `Future<Response>`: Response from the server

**Example:**
```dart
final response = await networkService.get(
  '/users',
  queryParameters: {'page': 1},
  useCache: true,
  cacheDuration: Duration(minutes: 5),
);
```

##### POST Request

```dart
Future<Response> post(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
})
```

**Parameters:**
- `path`: API endpoint path
- `data`: Request body data
- `queryParameters`: Optional query parameters
- `options`: Request options
- `cancelToken`: Token to cancel the request
- `onSendProgress`: Send progress callback
- `onReceiveProgress`: Receive progress callback

**Returns:**
- `Future<Response>`: Response from the server

**Example:**
```dart
final response = await networkService.post(
  '/users',
  data: {'name': 'John Doe', 'email': 'john@example.com'},
);
```

##### PUT Request

```dart
Future<Response> put(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
})
```

**Parameters:**
- `path`: API endpoint path
- `data`: Request body data
- `queryParameters`: Optional query parameters
- `options`: Request options
- `cancelToken`: Token to cancel the request
- `onSendProgress`: Send progress callback
- `onReceiveProgress`: Receive progress callback

**Returns:**
- `Future<Response>`: Response from the server

**Example:**
```dart
final response = await networkService.put(
  '/users/1',
  data: {'name': 'John Smith'},
);
```

##### DELETE Request

```dart
Future<Response> delete(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
})
```

**Parameters:**
- `path`: API endpoint path
- `data`: Request body data
- `queryParameters`: Optional query parameters
- `options`: Request options
- `cancelToken`: Token to cancel the request

**Returns:**
- `Future<Response>`: Response from the server

**Example:**
```dart
final response = await networkService.delete('/users/1');
```

##### Cache Management

```dart
void clearCacheForEndpoint(String endpoint)
void clearCache()
```

**Parameters:**
- `endpoint`: Specific endpoint to clear cache for

**Example:**
```dart
// Clear cache for specific endpoint
networkService.clearCacheForEndpoint('/users');

// Clear all cache
networkService.clearCache();
```

##### Request Debouncing

```dart
Future<T> debounce<T>(
  String key,
  Duration duration,
  Future<T> Function() request,
)
```

**Parameters:**
- `key`: Unique identifier for the debounced request
- `duration`: Debounce duration
- `request`: Request function to debounce

**Returns:**
- `Future<T>`: Result of the debounced request

**Example:**
```dart
final result = await networkService.debounce(
  'search',
  Duration(milliseconds: 500),
  () => networkService.get('/search?q=$query'),
);
```

## Error Handling

### Error Types

The application defines several custom exception types:

1. `NetworkException`
   - Thrown for network-related errors
   - Includes connection timeouts, network unavailability

2. `AuthenticationException`
   - Thrown for authentication failures
   - Includes invalid credentials, expired tokens

3. `AuthorizationException`
   - Thrown for permission issues
   - Includes insufficient permissions, access denied

4. `ValidationException`
   - Thrown for invalid request data
   - Includes missing fields, invalid formats

5. `ServerException`
   - Thrown for server-side errors
   - Includes 500 errors, service unavailability

6. `CacheException`
   - Thrown for caching-related errors
   - Includes cache read/write failures

7. `TokenException`
   - Thrown for token-related issues
   - Includes invalid tokens, token expiration

### Error Handler Service

The `ErrorHandlerService` provides methods for handling different types of errors:

```dart
void handleError(AppException exception)
void handleNetworkError(NetworkException exception)
void handleAuthError(AuthenticationException exception)
void handleValidationError(ValidationException exception)
```

**Example:**
```dart
try {
  final response = await networkService.get('/endpoint');
} catch (e) {
  errorHandler.handleError(e as AppException);
}
```

## Response Format

All API responses follow a standard format:

```json
{
  "data": {
    // Response data
  },
  "message": "Success message",
  "status": "success",
  "code": 200
}
```

### Error Response Format

```json
{
  "error": {
    "message": "Error message",
    "code": "ERROR_CODE",
    "details": {
      // Additional error details
    }
  },
  "status": "error",
  "code": 400
}
```

## Best Practices

1. Always use the provided error handling mechanisms
2. Implement proper caching for frequently accessed data
3. Use request debouncing for search and filter operations
4. Handle network connectivity changes appropriately
5. Implement proper error recovery mechanisms
6. Use appropriate timeouts for different operations
7. Implement proper logging for debugging
8. Follow the standard response format 