import 'package:devity_console/config/constants.dart';
import 'package:devity_console/config/environment.dart';
import 'package:devity_console/models/token_response.dart';
import 'package:devity_console/models/user.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:devity_console/services/token_storage_service.dart';
import 'package:devity_console/services/unprotected_api_service.dart';
import 'package:flutter/material.dart';

/// Authentication Service
class AuthService {
  final UnprotectedApiService _apiService;
  final TokenStorageService _tokenStorageService;

  /// Constructor
  AuthService({
    UnprotectedApiService? apiService,
    TokenStorageService? tokenStorageService,
  })  : _apiService = apiService ??
            UnprotectedApiService(
              networkService: NetworkService(
                errorHandler: ErrorHandlerService(),
              ),
              baseUrl: Environment.apiBaseUrl,
            ),
        _tokenStorageService = tokenStorageService ?? TokenStorageService();

  /// Login with email and password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      ) as Map<String, dynamic>;

      final tokenResponse =
          TokenResponse.fromJson(response['token'] as Map<String, dynamic>);
      await _tokenStorageService.saveToken(tokenResponse);

      return User.fromJson(response['user'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  /// Register a new user
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      ) as Map<String, dynamic>;

      final tokenResponse =
          TokenResponse.fromJson(response['token'] as Map<String, dynamic>);
      await _tokenStorageService.saveToken(tokenResponse);

      return User.fromJson(response['user'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
      await _tokenStorageService.clearToken();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      debugPrint('Password reset request error: $e');
      rethrow;
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiService.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } catch (e) {
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response =
          await _apiService.get('/auth/me') as Map<String, dynamic>;
      return User.fromJson(response);
    } catch (e) {
      debugPrint('Get current user error: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _tokenStorageService.getToken();
      return token != null;
    } catch (e) {
      debugPrint('Authentication check error: $e');
      return false;
    }
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    try {
      final currentToken = await _tokenStorageService.getToken();
      if (currentToken == null) {
        throw Exception('No token available to refresh');
      }

      final response = await _apiService.post(
        '/auth/refresh',
        data: {
          'refreshToken': currentToken.refreshToken,
        },
      ) as Map<String, dynamic>;

      final newToken = TokenResponse.fromJson(response);
      await _tokenStorageService.saveToken(newToken);
    } catch (e) {
      debugPrint('Token refresh error: $e');
      rethrow;
    }
  }
}
