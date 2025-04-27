import 'package:equatable/equatable.dart';

/// Base class for all app editor page list events.
abstract class AppEditorPageListEvent extends Equatable {
  const AppEditorPageListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start the page list.
class AppEditorPageListStartedEvent extends AppEditorPageListEvent {
  const AppEditorPageListStartedEvent();
}

/// Event to add a new page.
class AppEditorPageListAddPageEvent extends AppEditorPageListEvent {
  const AppEditorPageListAddPageEvent({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  List<Object?> get props => [name, description];
}

/// Event to update a page.
class AppEditorPageListUpdatePageEvent extends AppEditorPageListEvent {
  const AppEditorPageListUpdatePageEvent({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  @override
  List<Object?> get props => [id, name, description];
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
  const AppEditorPageListSearchEvent({
    required this.query,
  });

  final String query;

  @override
  List<Object?> get props => [query];
}
