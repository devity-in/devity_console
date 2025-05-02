import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
import 'package:devity_console/repositories/spec_editor_repository.dart';

part 'spec_editor_event.dart';
part 'spec_editor_state.dart';

/// [SpecEditorBloc] is a business logic component that manages the state of the
/// SpecEditor widget.
class SpecEditorBloc extends Bloc<SpecEditorEvent, SpecEditorState> {
  /// The default constructor for the [SpecEditorBloc].
  SpecEditorBloc({
    required this.projectId,
  }) : super(const SpecEditorInitialState()) {
    repository = SpecEditorRepository();
    on<SpecEditorStartedEvent>(_onStarted);
    on<SpecEditorSelectPageEvent>(_onSelectPage);
    on<SpecEditorSelectSectionEvent>(_onSelectSection);
    on<SpecEditorSelectLayoutEvent>(_onSelectLayout);
    on<SpecEditorSelectWidgetEvent>(_onSelectWidget);
    on<SpecEditorClearSelectionEvent>(_onClearSelection);
    on<SpecEditorPageAttributesUpdated>(_onPageAttributesUpdated);
    on<SpecEditorSectionAttributesUpdated>(_onSectionAttributesUpdated);
    on<SpecEditorLayoutAttributesUpdated>(_onLayoutAttributesUpdated);
    on<SpecEditorWidgetAttributesUpdated>(_onWidgetAttributesUpdated);
    on<SpecEditorSaveStateEvent>(_onSaveState);
    on<SpecEditorLoadStateEvent>(_onLoadState);
  }

  late final SpecEditorRepository repository;
  final String projectId;

  Future<void> _onStarted(
    SpecEditorStartedEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    emit(const SpecEditorLoadingState());
    try {
      emit(
        const SpecEditorLoadedState(),
      );
    } catch (e) {
      emit(SpecEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onSelectPage(
    SpecEditorSelectPageEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      emit(
        SpecEditorLoadedState(
          selectedPageId: event.id,
          editorState: currentState.editorState,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onSelectSection(
    SpecEditorSelectSectionEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final sectionAttributes =
          _getSectionAttributes(currentState.editorState, event.sectionType) ??
              {};

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: event.sectionType,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: sectionAttributes,
        ),
      );
    }
  }

  Future<void> _onSelectLayout(
    SpecEditorSelectLayoutEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final layoutAttributes = _getLayoutAttributes(
            currentState.editorState,
            event.sectionType,
            event.layoutIndex,
          ) ??
          {};

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: layoutAttributes,
        ),
      );
    }
  }

  Future<void> _onSelectWidget(
    SpecEditorSelectWidgetEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final widgetAttributes = _getWidgetAttributes(
            currentState.editorState,
            event.sectionType,
            event.layoutIndex,
            event.widgetIndex,
          ) ??
          {};

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          selectedWidgetIndex: event.widgetIndex,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onClearSelection(
    SpecEditorClearSelectionEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onPageAttributesUpdated(
    SpecEditorPageAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.pageAttributes)
            ..addAll(event.attributes);

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          pageAttributes: updatedAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onSectionAttributesUpdated(
    SpecEditorSectionAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.sectionAttributes)
            ..addAll(event.attributes);

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: updatedAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onLayoutAttributesUpdated(
    SpecEditorLayoutAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.layoutAttributes)
            ..addAll(event.attributes);

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: updatedAttributes,
          widgetAttributes: currentState.widgetAttributes,
        ),
      );
    }
  }

  Future<void> _onWidgetAttributesUpdated(
    SpecEditorWidgetAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.widgetAttributes)
            ..addAll(event.attributes);

      emit(
        SpecEditorLoadedState(
          selectedPageId: currentState.selectedPageId,
          editorState: currentState.editorState,
          selectedSectionType: currentState.selectedSectionType,
          selectedLayoutIndex: currentState.selectedLayoutIndex,
          selectedWidgetIndex: currentState.selectedWidgetIndex,
          pageAttributes: currentState.pageAttributes,
          sectionAttributes: currentState.sectionAttributes,
          layoutAttributes: currentState.layoutAttributes,
          widgetAttributes: updatedAttributes,
        ),
      );
    }
  }

  Future<void> _onSaveState(
    SpecEditorSaveStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      try {
        await repository.saveEditorState(
          projectId: projectId,
          state: currentState.editorState ?? {},
        );
      } catch (e) {
        emit(SpecEditorErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadState(
    SpecEditorLoadStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    emit(const SpecEditorLoadingState());
    try {
      final state = await repository.loadEditorState(projectId);
      emit(SpecEditorLoadedState(editorState: state));
    } catch (e) {
      emit(SpecEditorErrorState(message: e.toString()));
    }
  }

  Map<String, dynamic>? _getSectionAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
  ) {
    if (editorState == null) return null;
    final sections = editorState['sections'] as List?;
    if (sections == null) return null;
    final section = sections.firstWhere(
      (s) => s['type'] == sectionType.name,
      orElse: () => null,
    );
    return section?['attributes'] as Map<String, dynamic>?;
  }

  Map<String, dynamic>? _getLayoutAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
    int layoutIndex,
  ) {
    if (editorState == null) return null;
    final sections = editorState['sections'] as List?;
    if (sections == null) return null;
    final section = sections.firstWhere(
      (s) => s['type'] == sectionType.name,
      orElse: () => null,
    );
    if (section == null) return null;
    final layouts = section['layouts'] as List?;
    if (layouts == null || layoutIndex >= layouts.length) return null;
    return layouts[layoutIndex]['attributes'] as Map<String, dynamic>?;
  }

  Map<String, dynamic>? _getWidgetAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
    int layoutIndex,
    int widgetIndex,
  ) {
    if (editorState == null) return null;
    final sections = editorState['sections'] as List?;
    if (sections == null) return null;
    final section = sections.firstWhere(
      (s) => s['type'] == sectionType.name,
      orElse: () => null,
    );
    if (section == null) return null;
    final layouts = section['layouts'] as List?;
    if (layouts == null || layoutIndex >= layouts.length) return null;
    final widgets = layouts[layoutIndex]['widgets'] as List?;
    if (widgets == null || widgetIndex >= widgets.length) return null;
    return widgets[widgetIndex]['attributes'] as Map<String, dynamic>?;
  }
}
