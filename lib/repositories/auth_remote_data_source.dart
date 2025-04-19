import 'package:devity_console/models/user.dart';
import 'package:devity_console/models/token_response.dart';
import 'auth_data_source.dart';

class AuthRemoteDataSource implements AuthDataSource {
  @override
  Future<User> login(String email, String password) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );
  }

  @override
  Future<User> register(String email, String password, [String? name]) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '1',
      email: email,
      name: name,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<User?> getCurrentUser() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );
  }
}
