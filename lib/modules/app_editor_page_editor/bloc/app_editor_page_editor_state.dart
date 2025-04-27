part of 'app_editor_page_editor_bloc.dart';

/// Base class for page editor states
sealed class AppEditorPageEditorState {
  /// Creates a new instance of [AppEditorPageEditorState]
  const AppEditorPageEditorState();
}

/// Initial state of the page editor
class AppEditorPageEditorInitial extends AppEditorPageEditorState {
  /// Creates a new instance of [AppEditorPageEditorInitial]
  const AppEditorPageEditorInitial();
}

/// State when the page editor is loading
class AppEditorPageEditorLoading extends AppEditorPageEditorState {
  /// Creates a new instance of [AppEditorPageEditorLoading]
  const AppEditorPageEditorLoading();
}

/// State when the page editor is loaded
class AppEditorPageEditorLoaded extends AppEditorPageEditorState {
  /// Creates a new instance of [AppEditorPageEditorLoaded]
  const AppEditorPageEditorLoaded({
    this.sections = const [],
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
  });

  /// The sections in the page
  final List<PageSection> sections;

  /// The currently selected section type
  final PageSectionType? selectedSectionType;

  /// The index of the currently selected layout
  final int? selectedLayoutIndex;

  /// The index of the currently selected widget
  final int? selectedWidgetIndex;

  /// Creates a copy of this state with the given fields replaced with the new values
  AppEditorPageEditorLoaded copyWith({
    List<PageSection>? sections,
    PageSectionType? selectedSectionType,
    int? selectedLayoutIndex,
    int? selectedWidgetIndex,
  }) {
    return AppEditorPageEditorLoaded(
      sections: sections ?? this.sections,
      selectedSectionType: selectedSectionType ?? this.selectedSectionType,
      selectedLayoutIndex: selectedLayoutIndex ?? this.selectedLayoutIndex,
      selectedWidgetIndex: selectedWidgetIndex ?? this.selectedWidgetIndex,
    );
  }
}

/// State when there is an error in the page editor
class AppEditorPageEditorError extends AppEditorPageEditorState {
  /// Creates a new instance of [AppEditorPageEditorError]
  const AppEditorPageEditorError({required this.message});

  /// The error message
  final String message;
}
