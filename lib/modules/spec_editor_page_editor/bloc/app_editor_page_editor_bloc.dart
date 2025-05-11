import 'package:devity_console/modules/spec_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Consolidated Event Definitions
sealed class AppEditorPageEditorEvent extends Equatable {
  const AppEditorPageEditorEvent();

  @override
  List<Object?> get props => [];
}

final class AppEditorPageEditorInitialized extends AppEditorPageEditorEvent {
  const AppEditorPageEditorInitialized();
}

final class AppEditorPageLayoutUpdated extends AppEditorPageEditorEvent {
  const AppEditorPageLayoutUpdated({required this.layouts});
  final List<Layout> layouts;
  @override
  List<Object?> get props => [layouts];
}

final class AppEditorPageWidgetDropped extends AppEditorPageEditorEvent {
  const AppEditorPageWidgetDropped({
    required this.sectionType,
    required this.widgetData,
  });
  final PageSectionType sectionType;
  final dynamic widgetData;
  @override
  List<Object?> get props => [sectionType, widgetData];
}

final class AppEditorPageLayoutDropped extends AppEditorPageEditorEvent {
  const AppEditorPageLayoutDropped({
    required this.sectionType,
    required this.layoutType,
  });
  final PageSectionType sectionType;
  final LayoutType layoutType;
  @override
  List<Object?> get props => [sectionType, layoutType];
}

final class AppEditorPageWidgetReordered extends AppEditorPageEditorEvent {
  const AppEditorPageWidgetReordered({
    required this.sectionType,
    required this.layoutIndex,
    required this.oldIndex,
    required this.newIndex,
  });
  final PageSectionType sectionType;
  final int layoutIndex;
  final int oldIndex;
  final int newIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex, oldIndex, newIndex];
}

final class AppEditorPageSectionSelected extends AppEditorPageEditorEvent {
  const AppEditorPageSectionSelected({required this.sectionType});
  final PageSectionType sectionType;
  @override
  List<Object?> get props => [sectionType];
}

final class AppEditorPageLayoutSelected extends AppEditorPageEditorEvent {
  const AppEditorPageLayoutSelected({
    required this.sectionType,
    required this.layoutIndex,
  });
  final PageSectionType sectionType;
  final int layoutIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex];
}

final class AppEditorPageWidgetSelected extends AppEditorPageEditorEvent {
  const AppEditorPageWidgetSelected({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
  });
  final PageSectionType sectionType;
  final int layoutIndex;
  final int widgetIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex, widgetIndex];
}

final class AppEditorPageSelectionCleared extends AppEditorPageEditorEvent {
  const AppEditorPageSelectionCleared();
}

class AppEditorPageEditorSelectSection extends AppEditorPageEditorEvent {
  const AppEditorPageEditorSelectSection(this.sectionType);
  final PageSectionType sectionType;
  @override
  List<Object?> get props => [sectionType];
}

class AppEditorPageEditorSelectLayout extends AppEditorPageEditorEvent {
  const AppEditorPageEditorSelectLayout(this.sectionType, this.layoutIndex);
  final PageSectionType sectionType;
  final int layoutIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex];
}

class AppEditorPageEditorSelectWidget extends AppEditorPageEditorEvent {
  const AppEditorPageEditorSelectWidget(
    this.sectionType,
    this.layoutIndex,
    this.widgetIndex,
  );
  final PageSectionType sectionType;
  final int layoutIndex;
  final int widgetIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex, widgetIndex];
}

class AppEditorPageEditorClearSelection extends AppEditorPageEditorEvent {
  const AppEditorPageEditorClearSelection();
}

class PreviewElementTapped extends AppEditorPageEditorEvent {
  const PreviewElementTapped({this.elementId});
  final String? elementId;
  @override
  List<Object?> get props => [elementId];
}

// Consolidated State Definitions
sealed class AppEditorPageEditorState extends Equatable {
  const AppEditorPageEditorState();
  @override
  List<Object?> get props => [];
}

final class AppEditorPageEditorInitial extends AppEditorPageEditorState {
  const AppEditorPageEditorInitial();
}

final class AppEditorPageEditorLoading extends AppEditorPageEditorState {
  const AppEditorPageEditorLoading();
}

class AppEditorPageEditorLoaded extends AppEditorPageEditorState {
  const AppEditorPageEditorLoaded({
    this.sections = const [],
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
    this.selectedElementId,
  });
  final List<PageSection> sections;
  final PageSectionType? selectedSectionType;
  final int? selectedLayoutIndex;
  final int? selectedWidgetIndex;
  final String? selectedElementId;

  AppEditorPageEditorLoaded copyWith({
    List<PageSection>? sections,
    PageSectionType? selectedSectionType,
    int? selectedLayoutIndex,
    int? selectedWidgetIndex,
    String? selectedElementId,
    bool clearSelectedElementId = false,
  }) {
    return AppEditorPageEditorLoaded(
      sections: sections ?? this.sections,
      selectedSectionType: selectedSectionType ?? this.selectedSectionType,
      selectedLayoutIndex: selectedLayoutIndex ?? this.selectedLayoutIndex,
      selectedWidgetIndex: selectedWidgetIndex ?? this.selectedWidgetIndex,
      selectedElementId: clearSelectedElementId
          ? null
          : (selectedElementId ?? this.selectedElementId),
    );
  }

  @override
  List<Object?> get props => [
        sections,
        selectedSectionType,
        selectedLayoutIndex,
        selectedWidgetIndex,
        selectedElementId,
      ];
}

final class AppEditorPageEditorError extends AppEditorPageEditorState {
  const AppEditorPageEditorError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

/// [AppEditorPageEditorBloc] is a business logic component that manages the
/// state of the AppEditorPageEditor widget.
class AppEditorPageEditorBloc
    extends Bloc<AppEditorPageEditorEvent, AppEditorPageEditorState> {
  /// [AppEditorPageEditorBloc] constructor
  AppEditorPageEditorBloc() : super(const AppEditorPageEditorInitial()) {
    on<AppEditorPageEditorInitialized>(_onInitialized);
    on<AppEditorPageLayoutUpdated>(_onLayoutUpdated);
    on<AppEditorPageWidgetDropped>(_onWidgetDropped);
    on<AppEditorPageLayoutDropped>(_onLayoutDropped);
    on<AppEditorPageWidgetReordered>(_onWidgetReordered);
    on<AppEditorPageSectionSelected>(_onSectionSelected);
    on<AppEditorPageLayoutSelected>(_onLayoutSelected);
    on<AppEditorPageWidgetSelected>(_onWidgetSelected);
    on<AppEditorPageSelectionCleared>(_onSelectionCleared);
    on<AppEditorPageEditorSelectSection>(_onSelectSection);
    on<AppEditorPageEditorSelectLayout>(_onSelectLayout);
    on<AppEditorPageEditorSelectWidget>(_onSelectWidget);
    on<AppEditorPageEditorClearSelection>(_onClearSelection);
    on<PreviewElementTapped>(_onPreviewElementTapped);
  }

  Future<void> _onInitialized(
    AppEditorPageEditorInitialized event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    try {
      emit(const AppEditorPageEditorLoading());
      final sections = PageSectionType.values
          .map((type) => PageSection(type: type))
          .toList();
      emit(AppEditorPageEditorLoaded(sections: sections));
    } catch (e) {
      emit(AppEditorPageEditorError(message: e.toString()));
    }
  }

  Future<void> _onLayoutUpdated(
    AppEditorPageLayoutUpdated event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      if (currentState.sections.isNotEmpty) {
        final updatedSections = List<PageSection>.from(currentState.sections);
        // Replace layouts of the first section. This is a simplified handling.
        // A more robust solution would identify which section to update.
        updatedSections[0] =
            updatedSections[0].copyWith(layouts: event.layouts);
        emit(currentState.copyWith(sections: updatedSections));
      } else {
        // No sections to update, maybe emit an empty state or log
        emit(
          currentState.copyWith(),
        ); // Or emit current state if no change is made
      }
    } else {
      // If not loaded, perhaps initialize with new sections based on event.layouts
      // This case might need more thought based on desired behavior.
      emit(const AppEditorPageEditorLoaded());
    }
  }

  Future<void> _onWidgetDropped(
    AppEditorPageWidgetDropped event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    final sections = List<PageSection>.from(currentState.sections);
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);

    if (sectionIndex != -1) {
      final section = sections[sectionIndex];
      final updatedWidgets = List<dynamic>.from(section.widgets)
        ..add(event.widgetData);
      sections[sectionIndex] = section.copyWith(widgets: updatedWidgets);
      emit(currentState.copyWith(sections: sections));
    }
  }

  Future<void> _onLayoutDropped(
    AppEditorPageLayoutDropped event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    final sections = List<PageSection>.from(currentState.sections);
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);

    if (sectionIndex != -1) {
      final section = sections[sectionIndex];
      final updatedLayouts = List<Layout>.from(section.layouts)
        ..add(Layout(type: event.layoutType));
      sections[sectionIndex] = section.copyWith(layouts: updatedLayouts);
      emit(currentState.copyWith(sections: sections));
    }
  }

  void _onWidgetReordered(
    AppEditorPageWidgetReordered event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is! AppEditorPageEditorLoaded) return;

    final sections = List<PageSection>.from(currentState.sections);
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);
    if (sectionIndex == -1) return;

    final section = sections[sectionIndex];
    if (event.layoutIndex < 0 || event.layoutIndex >= section.layouts.length)
      return;

    final layout = section.layouts[event.layoutIndex];
    if (event.oldIndex < 0 ||
        event.oldIndex >= layout.widgets.length ||
        event.newIndex < 0 ||
        event.newIndex > layout.widgets.length) return;

    final widgets = List<dynamic>.from(layout.widgets);
    final widget = widgets.removeAt(event.oldIndex);
    widgets.insert(
      event.newIndex > widgets.length ? widgets.length : event.newIndex,
      widget,
    );

    final updatedLayouts = List<Layout>.from(section.layouts);
    updatedLayouts[event.layoutIndex] = layout.copyWith(widgets: widgets);
    sections[sectionIndex] = section.copyWith(layouts: updatedLayouts);

    emit(currentState.copyWith(sections: sections));
  }

  Future<void> _onSectionSelected(
    AppEditorPageSectionSelected event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    emit(
      currentState.copyWith(
        selectedSectionType: event.sectionType,
        clearSelectedElementId: true,
      ),
    );
  }

  Future<void> _onLayoutSelected(
    AppEditorPageLayoutSelected event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    emit(
      currentState.copyWith(
        selectedSectionType: event.sectionType,
        selectedLayoutIndex: event.layoutIndex,
        clearSelectedElementId: true,
      ),
    );
  }

  Future<void> _onWidgetSelected(
    AppEditorPageWidgetSelected event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    emit(
      currentState.copyWith(
        selectedSectionType: event.sectionType,
        selectedLayoutIndex: event.layoutIndex,
        selectedWidgetIndex: event.widgetIndex,
        clearSelectedElementId: true,
      ),
    );
  }

  Future<void> _onSelectionCleared(
    AppEditorPageSelectionCleared event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    if (state is! AppEditorPageEditorLoaded) return;
    final currentState = state as AppEditorPageEditorLoaded;
    emit(
      currentState.copyWith(
        clearSelectedElementId: true,
      ),
    );
  }

  void _onSelectSection(
    AppEditorPageEditorSelectSection event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          clearSelectedElementId: true,
        ),
      );
    } else {
      emit(AppEditorPageEditorLoaded(selectedSectionType: event.sectionType));
    }
  }

  void _onSelectLayout(
    AppEditorPageEditorSelectLayout event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          clearSelectedElementId: true,
        ),
      );
    } else {
      emit(
        AppEditorPageEditorLoaded(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
        ),
      );
    }
  }

  void _onSelectWidget(
    AppEditorPageEditorSelectWidget event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          selectedWidgetIndex: event.widgetIndex,
          clearSelectedElementId: true,
        ),
      );
    } else {
      emit(
        AppEditorPageEditorLoaded(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          selectedWidgetIndex: event.widgetIndex,
        ),
      );
    }
  }

  void _onClearSelection(
    AppEditorPageEditorClearSelection event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      emit(currentState.copyWith(clearSelectedElementId: true));
    }
  }

  void _onPreviewElementTapped(
    PreviewElementTapped event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is AppEditorPageEditorLoaded) {
      emit(
        currentState.copyWith(
          selectedElementId: event.elementId,
        ),
      );
    } else if (currentState is AppEditorPageEditorInitial ||
        currentState is AppEditorPageEditorLoading) {
      emit(AppEditorPageEditorLoaded(selectedElementId: event.elementId));
    }
  }
}
