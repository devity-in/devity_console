import 'package:equatable/equatable.dart';
import 'dart:convert';

class TokenResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  String encode() => jsonEncode(toJson());

  factory TokenResponse.fromString(String jsonString) {
    return TokenResponse.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn];
}
