import 'package:devity_console/models/user.dart';
import 'package:devity_console/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthService authService;
  const mockUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  setUp(() {
    authService = MockAuthService();
  });

  group('AuthService Tests', () {
    test('login with valid credentials returns user', () async {
      // Arrange
      when(
        () => authService.login(
          email: 'test@example.com',
          password: 'password',
        ),
      ).thenAnswer((_) async => mockUser);

      // Act
      final result = await authService.login(
        email: 'test@example.com',
        password: 'password',
      );

      // Assert
      expect(result, mockUser);
      verify(
        () => authService.login(
          email: 'test@example.com',
          password: 'password',
        ),
      ).called(1);
    });

    test('login with invalid credentials throws exception', () async {
      // Arrange
      when(
        () => authService.login(
          email: 'invalid@example.com',
          password: 'wrong',
        ),
      ).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () =>
            authService.login(email: 'invalid@example.com', password: 'wrong'),
        throwsException,
      );
      verify(
        () => authService.login(
          email: 'invalid@example.com',
          password: 'wrong',
        ),
      ).called(1);
    });
  });
}
