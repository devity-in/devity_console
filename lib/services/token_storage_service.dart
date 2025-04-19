import 'package:devity_console/models/token_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token storage service
class TokenStorageService {
  final _storage = const FlutterSecureStorage();
  static const String _tokenResponseKey = 'tokenResponse';

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

    return TokenResponse.fromString(token);
  }

  /// clear the token
  Future<void> clearToken() async {
    // Clear token from storage

    await _storage.delete(
      key: _tokenResponseKey,
    );
  }
}
