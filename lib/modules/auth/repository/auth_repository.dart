import 'package:devity_console/modules/auth/data_sources/auth_remote_data_source.dart';
import 'package:devity_console/modules/auth/exceptions/auth_exception.dart';
import 'package:devity_console/modules/auth/models/login.dart';
import 'package:devity_console/modules/auth/models/token_response.dart';
import 'package:devity_console/services/token_storage_service.dart';

/// Auth repository
class AuthRepository {
  /// Auth remote data source
  final AuthRemoteDataSource remoteDataSource;

  /// Auth local data source
  final TokenStorageService localDataSource;

  /// Auth repository constructor
  AuthRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// function to login to devity server
  Future<TokenResponse?> login(
    String username,
    String password,
  ) async {
    try {
      final loginData = LoginData(
        username: username,
        password: password,
      );
      final token = await remoteDataSource.login(loginData);
      await localDataSource.saveToken(token);
      return token;
    } on AuthException catch (e) {
      throw ParsedAuthException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout API call and clear token
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearToken();
  }

  Future<TokenResponse?> getToken() async {
    return localDataSource.getToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}
