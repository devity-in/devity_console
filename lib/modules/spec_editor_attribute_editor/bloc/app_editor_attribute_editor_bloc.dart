import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
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
    on<SelectedElementAttributesUpdated>(_onSelectedElementAttributesUpdated);
    on<SelectedElementSingleAttributeUpdated>(
      _onSelectedElementSingleAttributeUpdated,
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
    emit(
      AppEditorAttributeEditorLoaded(
        selectedSectionType: event.selectedSectionType,
        selectedLayoutIndex: event.selectedLayoutIndex,
        selectedWidgetIndex: event.selectedWidgetIndex,
        sectionAttributes: event.sectionAttributes ?? const {},
        layoutAttributes: event.layoutAttributes ?? const {},
        widgetAttributes: event.widgetAttributes ?? const {},
        globalActions: event.globalActions ?? const {},
      ),
    );
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
          globalActions: currentState.globalActions,
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
          globalActions: currentState.globalActions,
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
        currentState.copyWith(
          widgetAttributes: updatedAttributes,
        ),
      );
    }
  }

  void _onSelectedElementAttributesUpdated(
    SelectedElementAttributesUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      emit(
        currentState.copyWith(
          selectedElementAttributes: event.attributes,
          globalActions: event.globalActions,
          widgetAttributes: const {},
          layoutAttributes: const {},
          sectionAttributes: const {},
        ),
      );
    } else {
      emit(
        AppEditorAttributeEditorLoaded(
          selectedElementAttributes: event.attributes,
          globalActions: event.globalActions,
        ),
      );
    }
  }

  void _onSelectedElementSingleAttributeUpdated(
    SelectedElementSingleAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    if (state is AppEditorAttributeEditorLoaded) {
      final currentState = state as AppEditorAttributeEditorLoaded;
      if (currentState.selectedElementAttributes != null) {
        final updatedAttributes =
            Map<String, dynamic>.from(currentState.selectedElementAttributes!)
              ..[event.attributeKey] = event.newValue;

        emit(currentState.copyWith(
            selectedElementAttributes: updatedAttributes));

        // Call onCommit if provided
        if (event.onCommit != null) {
          final elementId = updatedAttributes['id'] as String?;
          if (elementId != null) {
            event.onCommit!(elementId, event.attributeKey, event.newValue);
          }
        }
      }
    }
  }
}
