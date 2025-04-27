part of 'app_editor_attribute_editor_bloc.dart';

/// Base class for attribute editor states
abstract class AppEditorAttributeEditorState extends Equatable {
  /// Creates a new instance of [AppEditorAttributeEditorState]
  const AppEditorAttributeEditorState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the attribute editor
class AppEditorAttributeEditorInitial extends AppEditorAttributeEditorState {
  /// Creates a new instance of [AppEditorAttributeEditorInitial]
  const AppEditorAttributeEditorInitial();
}

/// State when the attribute editor is loading
class AppEditorAttributeEditorLoading extends AppEditorAttributeEditorState {
  /// Creates a new instance of [AppEditorAttributeEditorLoading]
  const AppEditorAttributeEditorLoading();
}

/// State when the attribute editor is loaded
class AppEditorAttributeEditorLoaded extends AppEditorAttributeEditorState {
  /// Creates a new instance of [AppEditorAttributeEditorLoaded]
  const AppEditorAttributeEditorLoaded({required this.sections});

  /// The sections being edited
  final List<PageSection> sections;

  @override
  List<Object?> get props => [sections];
}

/// State when there is an error in the attribute editor
class AppEditorAttributeEditorError extends AppEditorAttributeEditorState {
  /// Creates a new instance of [AppEditorAttributeEditorError]
  const AppEditorAttributeEditorError({required this.message});

  /// The error message
  final String message;

  @override
  List<Object?> get props => [message];
}
