import 'package:devity_console/models/token_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token storage service
class TokenStorageService {
  final _storage = const FlutterSecureStorage();
  static const String _tokenResponseKey = 'tokenResponse';
  static const String _tokenInvalidationKey = 'tokenInvalidation';

  /// save the token object as string in secure storage
  Future<void> saveToken(TokenResponse token) async {
    // Save token to secure storage
    await _storage.write(
      key: _tokenResponseKey,
      value: token.encode(),
    );
  }

  /// get the token object from secure storage
  Future<TokenResponse?> getToken() async {
    // Retrieve token from storage
    final token = await _storage.read(key: _tokenResponseKey);
    if (token == null) {
      return null;
    }

    final tokenResponse = TokenResponse.fromString(token);

    // Check if token is invalidated
    final isInvalidated = await _isTokenInvalidated(tokenResponse);
    if (isInvalidated) {
      await clearToken();
      return null;
    }

    // Check if token is expired
    if (tokenResponse.isExpired) {
      await clearToken();
      return null;
    }

    return tokenResponse;
  }

  /// clear the token
  Future<void> clearToken() async {
    // Clear token from storage
    await _storage.delete(key: _tokenResponseKey);
  }

  /// Invalidate the current token
  Future<void> invalidateToken() async {
    final token = await getToken();
    if (token != null) {
      await _storage.write(
        key: _tokenInvalidationKey,
        value: token.accessToken,
      );
    }
  }

  /// Check if the token is invalidated
  Future<bool> _isTokenInvalidated(TokenResponse token) async {
    final invalidatedToken = await _storage.read(key: _tokenInvalidationKey);
    return invalidatedToken == token.accessToken;
  }

  /// Clear token invalidation
  Future<void> clearTokenInvalidation() async {
    await _storage.delete(key: _tokenInvalidationKey);
  }
}
