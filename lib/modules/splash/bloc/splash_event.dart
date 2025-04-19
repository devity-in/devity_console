import 'package:equatable/equatable.dart';

/// Base class for all splash events.
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status.
class CheckAuthStatus extends SplashEvent {}
