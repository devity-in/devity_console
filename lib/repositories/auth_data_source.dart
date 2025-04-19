import 'package:devity_console/models/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, [String? name]);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
