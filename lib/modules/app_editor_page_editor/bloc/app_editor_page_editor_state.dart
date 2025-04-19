part of 'app_editor_page_editor_bloc.dart';

/// States for the [AppEditorPageEditorBloc]
sealed class AppEditorPageEditorState {
  const AppEditorPageEditorState();
}

/// Initial state
class AppEditorPageEditorInitialState extends AppEditorPageEditorState {
  const AppEditorPageEditorInitialState();
}

/// Loading state
class AppEditorPageEditorLoadingState extends AppEditorPageEditorState {
  const AppEditorPageEditorLoadingState();
}

/// Loaded state
class AppEditorPageEditorLoadedState extends AppEditorPageEditorState {
  const AppEditorPageEditorLoadedState();
}

/// Error state
class AppEditorPageEditorErrorState extends AppEditorPageEditorState {
  const AppEditorPageEditorErrorState({
    required this.message,
  });

  final String message;
}
