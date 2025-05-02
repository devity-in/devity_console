part of 'spec_editor_bloc.dart';


/// States for the [SpecEditorBloc]
sealed class SpecEditorState {
  const SpecEditorState();
}

/// Initial state
class SpecEditorInitialState extends SpecEditorState {
  const SpecEditorInitialState();
}

/// Loading state
class SpecEditorLoadingState extends SpecEditorState {
  const SpecEditorLoadingState();
}

/// Loaded state with pages
class SpecEditorLoadedState extends SpecEditorState {
  const SpecEditorLoadedState({
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
class SpecEditorErrorState extends SpecEditorState {
  const SpecEditorErrorState({
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
