import 'package:devity_console/modules/app_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/page_section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_editor_page_editor_event.dart';
part 'app_editor_page_editor_state.dart';

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
  }

  Future<void> _onInitialized(
    AppEditorPageEditorInitialized event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    try {
      emit(const AppEditorPageEditorLoading());
      // Initialize with empty sections
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
    try {
      emit(const AppEditorPageEditorLoading());
      // TODO: Update the page layout
      if (state is AppEditorPageEditorLoaded) {
        final currentState = state as AppEditorPageEditorLoaded;
        emit(AppEditorPageEditorLoaded(sections: currentState.sections));
      } else {
        emit(const AppEditorPageEditorLoaded(sections: []));
      }
    } catch (e) {
      emit(AppEditorPageEditorError(message: e.toString()));
    }
  }

  Future<void> _onWidgetDropped(
    AppEditorPageWidgetDropped event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    try {
      if (state is! AppEditorPageEditorLoaded) return;

      final currentState = state as AppEditorPageEditorLoaded;
      final sections = List<PageSection>.from(currentState.sections);

      // Find the section to update
      final sectionIndex = sections.indexWhere(
        (section) => section.type == event.sectionType,
      );

      if (sectionIndex != -1) {
        // Create a new section with the added widget
        final section = sections[sectionIndex];
        final updatedWidgets = List<dynamic>.from(section.widgets)
          ..add(event.widgetData);

        sections[sectionIndex] = PageSection(
          type: section.type,
          widgets: updatedWidgets,
          layouts: section.layouts,
        );

        emit(AppEditorPageEditorLoaded(sections: sections));
      }
    } catch (e) {
      emit(AppEditorPageEditorError(message: e.toString()));
    }
  }

  Future<void> _onLayoutDropped(
    AppEditorPageLayoutDropped event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    try {
      if (state is! AppEditorPageEditorLoaded) return;

      final currentState = state as AppEditorPageEditorLoaded;
      final sections = List<PageSection>.from(currentState.sections);

      // Find the section to update
      final sectionIndex = sections.indexWhere(
        (section) => section.type == event.sectionType,
      );

      if (sectionIndex != -1) {
        // Create a new section with the added layout
        final section = sections[sectionIndex];
        final updatedLayouts = List<Layout>.from(section.layouts)
          ..add(Layout(type: event.layoutType));

        sections[sectionIndex] = PageSection(
          type: section.type,
          widgets: section.widgets,
          layouts: updatedLayouts,
        );

        emit(AppEditorPageEditorLoaded(sections: sections));
      }
    } catch (e) {
      emit(AppEditorPageEditorError(message: e.toString()));
    }
  }

  void _onWidgetReordered(
    AppEditorPageWidgetReordered event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    final state = this.state;
    if (state is! AppEditorPageEditorLoaded) return;

    final sections = List<PageSection>.from(state.sections);
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);
    if (sectionIndex == -1) return;

    final section = sections[sectionIndex];
    if (event.layoutIndex >= section.layouts.length) return;

    final layout = section.layouts[event.layoutIndex];
    if (event.oldIndex >= layout.widgets.length ||
        event.newIndex >= layout.widgets.length) return;

    final widgets = List<dynamic>.from(layout.widgets);
    final widget = widgets.removeAt(event.oldIndex);
    widgets.insert(event.newIndex, widget);

    final updatedLayout = layout.copyWith(widgets: widgets);
    final updatedLayouts = List<Layout>.from(section.layouts);
    updatedLayouts[event.layoutIndex] = updatedLayout;

    final updatedSection = section.copyWith(layouts: updatedLayouts);
    sections[sectionIndex] = updatedSection;

    emit(AppEditorPageEditorLoaded(sections: sections));
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
      currentState.copyWith(),
    );
  }

  void _onSelectSection(
    AppEditorPageEditorSelectSection event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    emit(
      AppEditorPageEditorLoaded(
        selectedSectionType: event.sectionType,
      ),
    );
  }

  void _onSelectLayout(
    AppEditorPageEditorSelectLayout event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    emit(
      AppEditorPageEditorLoaded(
        selectedSectionType: event.sectionType,
        selectedLayoutIndex: event.layoutIndex,
      ),
    );
  }

  void _onSelectWidget(
    AppEditorPageEditorSelectWidget event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    emit(
      AppEditorPageEditorLoaded(
        selectedSectionType: event.sectionType,
        selectedLayoutIndex: event.layoutIndex,
        selectedWidgetIndex: event.widgetIndex,
      ),
    );
  }

  void _onClearSelection(
    AppEditorPageEditorClearSelection event,
    Emitter<AppEditorPageEditorState> emit,
  ) {
    emit(
      const AppEditorPageEditorLoaded(),
    );
  }
}
