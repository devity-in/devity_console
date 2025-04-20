import 'package:devity_console/models/user.dart';
import 'package:devity_console/services/auth_service.dart';

/// Authentication Repository
class AuthRepository {
  final AuthService _authService;

  /// Constructor
  AuthRepository({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  /// Login with email and password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    return _authService.login(
      email: email,
      password: password,
    );
  }

  /// Register a new user
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return _authService.register(
      email: email,
      password: password,
      name: name,
    );
  }

  /// Logout the current user
  Future<void> logout() async {
    await _authService.logout();
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    await _authService.requestPasswordReset(email);
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _authService.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    return _authService.getCurrentUser();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _authService.isAuthenticated();
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    await _authService.refreshToken();
  }
}
