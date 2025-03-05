# Devity Flutter [ 3.29.0 ]
flutter project to serve as starting point for apps.

![coverage][coverage_badge]

---

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

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

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

---

## Data Modeling Using `freezed`

### Overview

In this project, we use the **`freezed`** library to generate immutable data classes, ensuring that our data models are safe, robust, and easy to work with. By leveraging code generation, we simplify the creation of models that handle equality, serialization, and state management efficiently.

### Why Use `freezed`?

- **Immutability**: Ensures data classes are immutable, making them safer and less prone to unintended mutations.
- **Automatic `==` and `hashCode`**: Avoid writing boilerplate code for equality checks and object comparison.
- **`copyWith` Method**: Easily create modified copies of existing objects without changing the original data.
- **Union and Sealed Classes**: Simplifies state management by enabling us to represent different states in a clean and structured way.
- **JSON Serialization Support**: Easily convert data classes to and from JSON using the `json_serializable` package.

### Installation

To use `freezed`, you need to add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  freezed_annotation: ^2.0.0
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.3.0
  freezed: ^2.0.0
  json_serializable: ^6.6.0
```

### Creating a Model with `freezed`

Below is an example of how to create an immutable model using `freezed`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

- The `@freezed` annotation is used to indicate that the class will have code generated by `freezed`.
- The `User` class is now immutable, and we can use the `copyWith` method to create new instances with modified values.

### Generating Code

After you define your model, you need to run the **code generator** to create the necessary files (`*.freezed.dart` and `*.g.dart`):

```bash
dart run build_runner build
```

This command generates:
- A `.freezed.dart` file for managing immutability, `copyWith`, equality, and unions.
- A `.g.dart` file for handling JSON serialization and deserialization, if needed.

### Example Usage

```dart
void main() {
  final user = User(id: 1, name: 'John Doe', email: 'john.doe@example.com');

  // Using copyWith to create a new User with a modified name
  final updatedUser = user.copyWith(name: 'Jane Doe');
  
  print(updatedUser.name);  // Output: Jane Doe

  // JSON Serialization
  final json = user.toJson();
  final newUser = User.fromJson(json);

  print(newUser);  // Output: User(id: 1, name: John Doe, email: john.doe@example.com)
}
```

### Using `freezed` for Other Features

Besides data modeling, `freezed` is also very useful for managing different application states, especially in state management libraries like `Bloc` or `Provider`.

#### Example: State Management with Union Classes

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
}
```

This allows you to handle different states (`authenticated`, `unauthenticated`, `loading`) cleanly, and it integrates well with state management systems.


```dart
void handleAuthState(AuthState state) {
  state.when(
    authenticated: (user) => print('User is authenticated'),
    unauthenticated: () => print('User is not authenticated'),
    loading: () => print('Loading...'),
  );
}
```

### Conclusion

The `freezed` library significantly improves the way we manage data and application states by reducing boilerplate code and enforcing immutability. We use it throughout this project to create models, manage states, and ensure that the code remains clean, maintainable, and easy to extend.

For more detailed usage, refer to the official [freezed documentation](https://pub.dev/packages/freezed).

---

### To sort the pubsec.yml

`dart run pubspec_dependency_sorter`