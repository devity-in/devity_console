# Devity Console [ 3.29.0 ]

[![codecov](https://codecov.io/gh/your-username/devity_console/branch/main/graph/badge.svg?token=YOUR_CODECOV_TOKEN)](https://codecov.io/gh/your-username/devity_console)

![coverage][coverage_badge]

A Flutter application with a robust API service implementation.

## Table of Contents
- [Getting Started](#getting-started-)
- [Features](#features)
- [Architecture](#architecture)
- [Development Workflow](#development-workflow)
- [Internationalization](#working-with-translations-)

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Devity Flutter works on iOS, Android, Web, and Windows._

## Features

### API Service Implementation

The application includes a comprehensive API service implementation with the following features:

#### 1. Request Caching
- In-memory caching for GET requests
- Configurable cache duration
- Automatic cache invalidation
- Methods to clear cache for specific endpoints or entire cache
- Cache key generation based on URL and query parameters

#### 2. Retry Mechanism
- Automatic retry for failed requests
- Configurable maximum retry attempts
- Exponential backoff delay between retries
- Network connectivity check before each retry
- Comprehensive error handling

#### 3. Request Debouncing
- Prevents multiple rapid requests to the same endpoint
- Configurable debounce duration
- Ability to cancel debounced requests
- Automatic cleanup of debounce timers

#### 4. Network Connectivity Monitoring
- Real-time network status monitoring
- Automatic handling of offline/online transitions
- Network-aware request handling
- Proper error handling for network-related issues

#### 5. Authentication
- JWT token-based authentication
- Automatic token refresh
- Token expiration handling
- Secure token storage
- Authorization header management

#### 6. Error Handling
- Comprehensive error types
- User-friendly error messages
- Stack trace preservation
- Error logging
- Network-specific error handling

### Usage Examples

#### Cached GET Request
```dart
final response = await apiService.get(
  '/endpoint',
  useCache: true,
  cacheDuration: const Duration(minutes: 5),
);
```

#### Debounced Request
```dart
networkService.debounce(
  'search',
  const Duration(milliseconds: 500),
  () => apiService.get('/search?q=$query'),
);
```

#### Network Connectivity Monitoring
```dart
networkService.connectivityStream.listen((result) {
  if (result == ConnectivityResult.none) {
    // Handle offline state
  } else {
    // Handle online state
  }
});
```

#### Cache Management
```dart
// Clear specific endpoint cache
apiService.clearCacheForEndpoint('/endpoint');

// Clear all cache
apiService.clearCache();
```

## Architecture

The API service implementation follows a layered architecture:

1. **NetworkService**: Core network operations, caching, and connectivity
2. **AuthenticatedApiService**: Authentication and API-specific operations
3. **TokenStorageService**: Secure token storage
4. **ErrorHandlerService**: Error handling and user feedback

### Error Types

The application defines specific error types for different scenarios:

- `NetworkException`: Network-related errors
- `AuthenticationException`: Authentication failures
- `AuthorizationException`: Permission issues
- `ValidationException`: Invalid request data
- `ServerException`: Server-side errors
- `CacheException`: Caching-related errors
- `TokenException`: Token-related issues

### Dependencies

- dio: ^5.8.0+1
- connectivity_plus: ^5.0.2
- flutter_secure_storage: ^4.2.1
- shared_preferences: ^2.2.2
- equatable: ^2.0.5

### Best Practices

1. Always use the API service for network requests
2. Implement proper error handling
3. Use caching for frequently accessed data
4. Monitor network connectivity
5. Handle token expiration gracefully
6. Clean up resources when done

## Development Workflow

### Running Tests 🧪

To run all unit and widget tests with coverage:

```sh
# Run tests with coverage
$ flutter test --coverage

# Generate HTML coverage report
$ genhtml coverage/lcov.info -o coverage/html

# Open coverage report in browser
$ open coverage/html/index.html
```

The project maintains a minimum of 80% test coverage. Coverage reports are automatically generated on each pull request and can be viewed in the GitHub Actions artifacts.

### Managing Dependencies

To sort the pubspec.yml:

```sh
dart run pubspec_dependency_sorter
```

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:devity_flutter/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
