part of 'app_editor_bloc.dart';

/// States for the [AppEditorBloc]
sealed class AppEditorState {
  const AppEditorState();
}

/// Initial state
class AppEditorInitialState extends AppEditorState {
  const AppEditorInitialState();
}

/// Loading state
class AppEditorLoadingState extends AppEditorState {
  const AppEditorLoadingState();
}

/// Loaded state with pages
class AppEditorLoadedState extends AppEditorState {
  const AppEditorLoadedState({
    required this.pages,
    this.selectedPageId,
    this.editorState,
  });

  final List<AppPage> pages;
  final String? selectedPageId;
  final Map<String, dynamic>? editorState;
}

/// Error state
class AppEditorErrorState extends AppEditorState {
  const AppEditorErrorState({
    required this.message,
  });

  final String message;
}

/// Model for an app page
class AppPage {
  /// Creates a new [AppPage]
  const AppPage({
    required this.id,
    required this.name,
    required this.description,
  });

  /// The unique identifier of the page
  final String id;

  /// The name of the page
  final String name;

  /// The description of the page
  final String description;
}
