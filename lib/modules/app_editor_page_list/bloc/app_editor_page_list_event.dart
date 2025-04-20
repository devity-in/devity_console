part of 'app_editor_page_list_bloc.dart';

/// Events for the [AppEditorPageListBloc]
sealed class AppEditorPageListEvent {
  const AppEditorPageListEvent();
}

/// Initial event when the app editor page list is started
class AppEditorPageListStartedEvent extends AppEditorPageListEvent {
  const AppEditorPageListStartedEvent();
}

/// Event to add a new page
class AppEditorPageListAddPageEvent extends AppEditorPageListEvent {
  const AppEditorPageListAddPageEvent({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

/// Event to delete a page
class AppEditorPageListDeletePageEvent extends AppEditorPageListEvent {
  const AppEditorPageListDeletePageEvent({
    required this.pageId,
  });

  final String pageId;
}
