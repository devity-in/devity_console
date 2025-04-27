import 'package:devity_console/modules/app_editor_page_editor/models/page_section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_editor_attribute_editor_event.dart';
part 'app_editor_attribute_editor_state.dart';

/// Base class for attribute editor events
abstract class AppEditorAttributeEditorEvent extends Equatable {
  /// Creates a new instance of [AppEditorAttributeEditorEvent]
  const AppEditorAttributeEditorEvent();

  @override
  List<Object?> get props => [];
}

/// BLoC for managing attribute editor state
class AppEditorAttributeEditorBloc
    extends Bloc<AppEditorAttributeEditorEvent, AppEditorAttributeEditorState> {
  /// Creates a new instance of [AppEditorAttributeEditorBloc]
  AppEditorAttributeEditorBloc()
      : super(const AppEditorAttributeEditorInitial()) {
    on<AppEditorAttributeEditorLoad>(_onLoad);
    on<AppEditorAttributeEditorWidgetAttributeUpdated>(
      _onWidgetAttributeUpdated,
    );
    on<AppEditorAttributeEditorLayoutAttributeUpdated>(
      _onLayoutAttributeUpdated,
    );
    on<AppEditorAttributeEditorSectionAttributeUpdated>(
      _onSectionAttributeUpdated,
    );
  }

  void _onLoad(
    AppEditorAttributeEditorLoad event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    emit(AppEditorAttributeEditorLoaded(sections: event.sections));
  }

  void _onWidgetAttributeUpdated(
    AppEditorAttributeEditorWidgetAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    final state = this.state;
    if (state is! AppEditorAttributeEditorLoaded) return;

    final sections = state.sections.toList();
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);
    if (sectionIndex == -1) return;

    final section = sections[sectionIndex];
    if (event.layoutIndex >= section.layouts.length) return;

    final layout = section.layouts[event.layoutIndex];
    if (event.widgetIndex >= layout.widgets.length) return;

    final updatedWidget = layout.widgets[event.widgetIndex].copyWith(
      attributes: event.attributes,
    );

    final updatedLayout = layout.copyWith(
      widgets: List.from(layout.widgets)..[event.widgetIndex] = updatedWidget,
    );

    sections[sectionIndex] = section.copyWith(
      layouts: List.from(section.layouts)..[event.layoutIndex] = updatedLayout,
    );

    emit(AppEditorAttributeEditorLoaded(sections: sections));
  }

  void _onLayoutAttributeUpdated(
    AppEditorAttributeEditorLayoutAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    final state = this.state;
    if (state is! AppEditorAttributeEditorLoaded) return;

    final sections = state.sections.toList();
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);
    if (sectionIndex == -1) return;

    final section = sections[sectionIndex];
    if (event.layoutIndex >= section.layouts.length) return;

    final layout = section.layouts[event.layoutIndex];
    final updatedLayout = layout.copyWith(attributes: event.attributes);

    sections[sectionIndex] = section.copyWith(
      layouts: List.from(section.layouts)..[event.layoutIndex] = updatedLayout,
    );

    emit(AppEditorAttributeEditorLoaded(sections: sections));
  }

  void _onSectionAttributeUpdated(
    AppEditorAttributeEditorSectionAttributeUpdated event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) {
    final state = this.state;
    if (state is! AppEditorAttributeEditorLoaded) return;

    final sections = state.sections.toList();
    final sectionIndex =
        sections.indexWhere((s) => s.type == event.sectionType);
    if (sectionIndex == -1) return;

    final section = sections[sectionIndex];
    sections[sectionIndex] = section.copyWith(attributes: event.attributes);

    emit(AppEditorAttributeEditorLoaded(sections: sections));
  }
}
