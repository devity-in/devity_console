import 'dart:convert';

/// Model for login data
class LoginData {
  /// username
  final String username;

  /// password
  final String password;

  /// Constructor
  LoginData({
    required this.username,
    required this.password,
  });

  /// Convert the model to a JSON
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  /// Convert the model to a JSON string
  String encode() => json.encode(toJson());
}
