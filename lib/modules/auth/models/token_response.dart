import 'dart:convert';

/// Model for token response
class TokenResponse {
  /// Constructor
  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  /// factory constructor
  factory TokenResponse.fromString(String jsonString) {
    // Decode the JSON string
    final parsedJson = json.decode(jsonString) as Map<String, dynamic>;
    return TokenResponse.fromJson(parsedJson);
  }

  /// factory constructor
  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }

  /// Token
  final String accessToken;

  /// Refresh token
  final String refreshToken;

  /// Token type
  final String tokenType;

  /// Convert the model to a JSON string
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': tokenType,
      };

  /// Convert the model to a JSON string
  String encode() => json.encode(toJson());
}
