import 'package:devity_console/modules/app_editor_page_editor/models/page_section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_editor_attribute_editor_event.dart';
part 'app_editor_attribute_editor_state.dart';

/// [AppEditorAttributeEditorBloc] manages the state of the attribute editor.
class AppEditorAttributeEditorBloc
    extends Bloc<AppEditorAttributeEditorEvent, AppEditorAttributeEditorState> {
  /// Creates a new instance of [AppEditorAttributeEditorBloc].
  AppEditorAttributeEditorBloc()
      : super(const AppEditorAttributeEditorInitial()) {
    on<AppEditorAttributeEditorInitialized>(_onInitialized);
    on<AppEditorAttributeEditorSelectionChanged>(_onSelectionChanged);
    on<AppEditorAttributeEditorSectionAttributeUpdated>(
      _onSectionAttributeUpdated,
    );
    on<AppEditorAttributeEditorLayoutAttributeUpdated>(
      _onLayoutAttributeUpdated,
    );
    on<AppEditorAttributeEditorWidgetAttributeUpdated>(
      _onWidgetAttributeUpdated,
    );
  }

  void _onInitialized(
    AppEditorAttributeEditorInitialized event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    emit(const AppEditorAttributeEditorLoaded());
  }

  void _onSelectionChanged(
    AppEditorAttributeEditorSelectionChanged event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      emit(
        AppEditorAttributeEditorLoaded(
          selectedSectionType:
              event.selectedSectionType ?? currentState.selectedSectionType,
          selectedLayoutIndex:
              event.selectedLayoutIndex ?? currentState.selectedLayoutIndex,
          selectedWidgetIndex:
              event.selectedWidgetIndex ?? currentState.selectedWidgetIndex,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  void _onSectionAttributeUpdated(
    AppEditorAttributeEditorSectionAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.sectionAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorAttributeEditorLoaded(
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          sectionAttributes: updatedAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  void _onLayoutAttributeUpdated(
    AppEditorAttributeEditorLayoutAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.layoutAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorAttributeEditorLoaded(
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: updatedAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  void _onWidgetAttributeUpdated(
    AppEditorAttributeEditorWidgetAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.widgetAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorAttributeEditorLoaded(
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: updatedAttributes,
        ),
      );
    }
  }
}
