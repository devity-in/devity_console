import 'package:devity_console/models/user.dart';
import 'package:devity_console/exceptions/auth_exceptions.dart';
import 'auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<User> login(String email, String password) async {
    try {
      return await _dataSource.login(email, password);
    } catch (e) {
      throw AuthException('Failed to login: ${e.toString()}');
    }
  }

  Future<User> register(String email, String password, [String? name]) async {
    try {
      return await _dataSource.register(email, password, name);
    } catch (e) {
      throw AuthException('Failed to register: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
    } catch (e) {
      throw AuthException(
          'Failed to send password reset email: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } catch (e) {
      throw AuthException('Failed to logout: ${e.toString()}');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return await _dataSource.getCurrentUser();
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }
}
