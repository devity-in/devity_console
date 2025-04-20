part of 'app_editor_page_list_bloc.dart';

/// States for the [AppEditorPageListBloc]
sealed class AppEditorPageListState {
  const AppEditorPageListState();
}

/// Initial state
class AppEditorPageListInitialState extends AppEditorPageListState {
  const AppEditorPageListInitialState();
}

/// Loading state
class AppEditorPageListLoadingState extends AppEditorPageListState {
  const AppEditorPageListLoadingState();
}

/// Loaded state with pages
class AppEditorPageListLoadedState extends AppEditorPageListState {
  const AppEditorPageListLoadedState({
    required this.pages,
  });

  final List<Page> pages;
}

/// Error state
class AppEditorPageListErrorState extends AppEditorPageListState {
  const AppEditorPageListErrorState({
    required this.message,
  });

  final String message;
}

/// [Page] is a class that represents a page in the AppEditorPageList widget.
class Page {
  /// Creates a new instance of [Page].
  const Page({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
}
