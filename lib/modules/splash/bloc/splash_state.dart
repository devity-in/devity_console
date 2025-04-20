import 'package:equatable/equatable.dart';

/// Base class for all splash states.
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the splash screen.
class SplashInitial extends SplashState {}

/// The state when the splash screen is loading.
class SplashLoading extends SplashState {}

/// The state when the user is authenticated.
class SplashAuthenticated extends SplashState {
  /// The ID of the authenticated user.
  final String userId;

  /// Creates a new [SplashAuthenticated].
  const SplashAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// The state when the user is not authenticated.
class SplashUnauthenticated extends SplashState {}

/// The state when there was an error.
class SplashError extends SplashState {
  /// The error message.
  final String message;

  /// Creates a new [SplashError].
  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
