import 'package:equatable/equatable.dart';

/// Base class for all app editor page list events.
abstract class AppEditorPageListEvent extends Equatable {
  const AppEditorPageListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start loading the page list.
class AppEditorPageListStartedEvent extends AppEditorPageListEvent {
  const AppEditorPageListStartedEvent();
}

/// Event to add a new page.
class AppEditorPageListAddPageEvent extends AppEditorPageListEvent {
  const AppEditorPageListAddPageEvent({
    required this.name,
    this.description,
  });

  final String name;
  final String? description;

  @override
  List<Object?> get props => [name, description];
}

/// Event to delete a page.
class AppEditorPageListDeletePageEvent extends AppEditorPageListEvent {
  const AppEditorPageListDeletePageEvent({
    required this.pageId,
  });

  final String pageId;

  @override
  List<Object?> get props => [pageId];
}

/// Event to search pages.
class AppEditorPageListSearchEvent extends AppEditorPageListEvent {
  const AppEditorPageListSearchEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
