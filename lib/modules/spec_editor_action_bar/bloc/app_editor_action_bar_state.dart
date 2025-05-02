import 'package:equatable/equatable.dart';

abstract class AppEditorActionBarState extends Equatable {
  const AppEditorActionBarState();

  @override
  List<Object> get props => [];
}

class AppEditorActionBarInitial extends AppEditorActionBarState {}

class AppEditorActionBarLoading extends AppEditorActionBarState {}

class AppEditorActionBarLoaded extends AppEditorActionBarState {
  final String lastSaved;
  final bool isDirty;

  const AppEditorActionBarLoaded({
    required this.lastSaved,
    required this.isDirty,
  });

  @override
  List<Object> get props => [lastSaved, isDirty];
}

class AppEditorActionBarError extends AppEditorActionBarState {
  final String message;

  const AppEditorActionBarError(this.message);

  @override
  List<Object> get props => [message];
}
