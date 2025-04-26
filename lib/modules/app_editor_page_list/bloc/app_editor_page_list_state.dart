import 'package:devity_console/modules/app_editor_page_list/models/page.dart'
    as models;
import 'package:equatable/equatable.dart';

/// Base class for all app editor page list states.
abstract class AppEditorPageListState extends Equatable {
  const AppEditorPageListState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the app editor page list.
class AppEditorPageListInitialState extends AppEditorPageListState {
  const AppEditorPageListInitialState();
}

/// The state when the app editor page list is loading.
class AppEditorPageListLoadingState extends AppEditorPageListState {
  const AppEditorPageListLoadingState();
}

/// The state when the app editor page list has been loaded successfully.
class AppEditorPageListLoadedState extends AppEditorPageListState {
  const AppEditorPageListLoadedState({
    required this.pages,
  });

  /// The list of pages.
  final List<models.Page> pages;

  @override
  List<Object?> get props => [pages];
}

/// The state when there was an error loading the app editor page list.
class AppEditorPageListErrorState extends AppEditorPageListState {
  const AppEditorPageListErrorState({
    required this.message,
  });

  /// The error message.
  final String message;

  @override
  List<Object?> get props => [message];
}
