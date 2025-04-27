part of 'app_editor_bloc.dart';

/// Events for the [AppEditorBloc]
sealed class AppEditorEvent {
  const AppEditorEvent();
}

/// Initial event when the app editor is started
class AppEditorStartedEvent extends AppEditorEvent {
  const AppEditorStartedEvent();
}

/// Event to select a page
class AppEditorSelectPageEvent extends AppEditorEvent {
  const AppEditorSelectPageEvent({
    required this.id,
  });

  final String id;
}

/// Event to save the editor state
class AppEditorSaveStateEvent extends AppEditorEvent {
  const AppEditorSaveStateEvent({
    required this.state,
  });

  final Map<String, dynamic> state;
}

/// Event to load the editor state
class AppEditorLoadStateEvent extends AppEditorEvent {
  const AppEditorLoadStateEvent();
}
