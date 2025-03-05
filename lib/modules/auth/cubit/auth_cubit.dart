// auth_cubit.dart
import 'package:devity_console/modules/auth/cubit/cubit.dart';
import 'package:devity_console/modules/auth/data_sources/auth_remote_data_source.dart';
import 'package:devity_console/modules/auth/exceptions/auth_exception.dart';
import 'package:devity_console/modules/auth/repository/auth_repository.dart';
import 'package:devity_console/services/snackbar_service.dart';
import 'package:devity_console/services/token_storage_service.dart';

/// Auth cubit
class AuthCubit extends Cubit<AuthState> {
  /// Constructor
  AuthCubit() : super(AuthInitial()) {
    _authRepository = AuthRepository(
      remoteDataSource: _authRemoteDataSource,
      localDataSource: _authLocalDataSource,
    );
  }

  final _authLocalDataSource = TokenStorageService();
  final _authRemoteDataSource = AuthRemoteDataSource();
  late final AuthRepository _authRepository;

  /// App started
  Future<void> appStarted() async {
    // Check if the user is authenticated (e.g., check token in storage)
    final token = await _authRepository.getToken();
    final isLoggedIn = token != null;

    if (isLoggedIn) {
      emit(Authenticated(token));
    } else {
      emit(Unauthenticated());
    }
  }

  /// Log in
  Future<void> logIn(String email, String password) async {
    try {
      // Log in with email and password
      final token = await _authRepository.login(email, password);
      emit(Authenticated(token));
      snackbarService.showPositiveSnackbar(
        'Logged in successfully',
      );
    } on ParsedAuthException catch (e) {
      snackbarService.showNegativeSnackbar(e.message);
    } catch (e) {
      snackbarService.showNegativeSnackbar(
        'Error : $e \n Type: ${e.runtimeType}',
      );
      emit(Unauthenticated());
    }
  }

  /// Log out
  Future<void> logOut() async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
