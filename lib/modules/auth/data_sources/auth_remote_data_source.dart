import 'package:devity_console/config/constants.dart';
import 'package:devity_console/modules/auth/exceptions/auth_exception.dart';
import 'package:devity_console/modules/auth/models/login.dart';
import 'package:devity_console/modules/auth/models/token_response.dart';
import 'package:http/http.dart' as http;

/// Auth remote data source
class AuthRemoteDataSource {
  /// Login API call
  static String baseUrl = Constants.baseUrl;

  /// function to login to devity server
  Future<TokenResponse> login(LoginData loginData) async {
    try {
      // Make an HTTP request and return the token
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: loginData.encode(),
      );
      // Check the status code
      if (response.statusCode == 200) {
        return TokenResponse.fromString(response.body);
      } else {
        throw AuthException(
          response.body,
          code: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logout API call
  Future<void> logout() async {
    // Make an HTTP request to logout
  }
}
