# Contributing to Devity Console

Thank you for your interest in contributing to Devity Console! This document provides guidelines and steps for contributing to our project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) in all your interactions with the project.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/devity_console.git
   cd devity_console
   ```
3. Set up the development environment:
   - Install Flutter SDK (version specified in pubspec.yaml)
   - Run `flutter pub get` to install dependencies
   - Set up environment variables (see .env.example)

## Development Process

1. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following our coding standards

3. Test your changes thoroughly

4. Commit your changes with a descriptive message:
   ```bash
   git commit -m "feat: add new feature"  # for new features
   git commit -m "fix: resolve bug"       # for bug fixes
   git commit -m "docs: update docs"      # for documentation
   ```

## Pull Request Process

1. Ensure your branch is up to date with the main branch
2. Push your changes to your fork
3. Create a Pull Request (PR) with:
   - Clear title and description
   - Reference to any related issues
   - Screenshots or videos for UI changes
4. Wait for review and address any feedback

## Coding Standards

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Write clear and concise comments
- Keep functions small and focused
- Follow the BLoC pattern for state management
- Use proper error handling

## Testing

### Test Coverage Requirements
- Maintain a minimum of 80% test coverage for all new code
- All critical paths must be covered by tests
- UI components must have widget tests
- Business logic must have unit tests
- Integration tests for key user flows

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Test Types
1. **Unit Tests**
   - Test individual functions and classes
   - Focus on business logic
   - Use mock objects for dependencies

2. **Widget Tests**
   - Test UI components in isolation
   - Verify widget rendering and interactions
   - Test different states and configurations

3. **Integration Tests**
   - Test complete user flows
   - Verify app behavior across screens
   - Test real-world scenarios

### Continuous Integration
- All tests must pass before merging
- Coverage reports are generated automatically
- PRs with coverage below 80% will be rejected
- Code quality checks are run on every PR

## Documentation

- Update documentation for new features
- Add comments for complex logic
- Keep README.md up to date
- Document API changes
- Update CHANGELOG.md for significant changes

## Questions?

Feel free to open an issue if you have any questions about contributing to the project. 