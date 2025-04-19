part of 'app_editor_bloc.dart';

/// Events for the [AppEditorBloc]
sealed class AppEditorEvent {
  const AppEditorEvent();
}

/// Initial event when the app editor is started
class AppEditorStartedEvent extends AppEditorEvent {
  const AppEditorStartedEvent();
}

/// Event to create a new page
class AppEditorCreatePageEvent extends AppEditorEvent {
  const AppEditorCreatePageEvent({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

/// Event to update a page
class AppEditorUpdatePageEvent extends AppEditorEvent {
  const AppEditorUpdatePageEvent({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}

/// Event to delete a page
class AppEditorDeletePageEvent extends AppEditorEvent {
  const AppEditorDeletePageEvent({
    required this.id,
  });

  final String id;
}

/// Event to select a page
class AppEditorSelectPageEvent extends AppEditorEvent {
  const AppEditorSelectPageEvent({
    required this.id,
  });

  final String id;
}
