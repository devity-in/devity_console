import 'package:equatable/equatable.dart';
import 'dart:convert';

class TokenResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    DateTime? issuedAt,
  }) : issuedAt = issuedAt ?? DateTime.now();

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'issued_at': issuedAt.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());

  factory TokenResponse.fromString(String jsonString) {
    return TokenResponse.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// Check if the access token is expired
  bool get isExpired {
    final expirationTime = issuedAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expirationTime);
  }

  /// Check if the access token will expire within the specified duration
  bool willExpireIn(Duration duration) {
    final expirationTime = issuedAt.add(Duration(seconds: expiresIn));
    final checkTime = DateTime.now().add(duration);
    return checkTime.isAfter(expirationTime);
  }

  @override
  List<Object?> get props =>
      [accessToken, refreshToken, tokenType, expiresIn, issuedAt];
}
