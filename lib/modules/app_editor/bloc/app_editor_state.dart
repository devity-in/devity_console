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
    this.selectedPageId,
    this.editorState,
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
    this.pageAttributes = const {},
    this.sectionAttributes = const {},
    this.layoutAttributes = const {},
    this.widgetAttributes = const {},
  });

  /// The ID of the currently selected page
  final String? selectedPageId;

  /// The current editor state
  final Map<String, dynamic>? editorState;

  /// The type of the currently selected section
  final PageSectionType? selectedSectionType;

  /// The index of the currently selected layout
  final int? selectedLayoutIndex;

  /// The index of the currently selected widget
  final int? selectedWidgetIndex;

  /// The attributes for the selected page
  final Map<String, dynamic> pageAttributes;

  /// The attributes for the selected section
  final Map<String, dynamic> sectionAttributes;

  /// The attributes for the selected layout
  final Map<String, dynamic> layoutAttributes;

  /// The attributes for the selected widget
  final Map<String, dynamic> widgetAttributes;
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
