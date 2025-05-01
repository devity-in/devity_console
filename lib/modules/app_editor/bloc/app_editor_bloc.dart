import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/page_section.dart';
import 'package:devity_console/repositories/app_editor_repository.dart';

part 'app_editor_event.dart';
part 'app_editor_state.dart';

/// [AppEditorBloc] is a business logic component that manages the state of the
/// AppEditor widget.
class AppEditorBloc extends Bloc<AppEditorEvent, AppEditorState> {
  /// The default constructor for the [AppEditorBloc].
  AppEditorBloc({
    required this.projectId,
  }) : super(const AppEditorInitialState()) {
    repository = AppEditorRepository();
    on<AppEditorStartedEvent>(_onStarted);
    on<AppEditorSelectPageEvent>(_onSelectPage);
    on<AppEditorSelectSectionEvent>(_onSelectSection);
    on<AppEditorSelectLayoutEvent>(_onSelectLayout);
    on<AppEditorSelectWidgetEvent>(_onSelectWidget);
    on<AppEditorClearSelectionEvent>(_onClearSelection);
    on<AppEditorPageAttributesUpdated>(_onPageAttributesUpdated);
    on<AppEditorSectionAttributesUpdated>(_onSectionAttributesUpdated);
    on<AppEditorLayoutAttributesUpdated>(_onLayoutAttributesUpdated);
    on<AppEditorWidgetAttributesUpdated>(_onWidgetAttributesUpdated);
    on<AppEditorSaveStateEvent>(_onSaveState);
    on<AppEditorLoadStateEvent>(_onLoadState);
  }

  late final AppEditorRepository repository;
  final String projectId;

  Future<void> _onStarted(
    AppEditorStartedEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      emit(
        const AppEditorLoadedState(),
      );
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onSelectPage(
    AppEditorSelectPageEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      emit(
        AppEditorLoadedState(
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
    AppEditorSelectSectionEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final sectionAttributes =
          _getSectionAttributes(currentState.editorState, event.sectionType) ??
              {};

      emit(
        AppEditorLoadedState(
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
    AppEditorSelectLayoutEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final layoutAttributes = _getLayoutAttributes(
            currentState.editorState,
            event.sectionType,
            event.layoutIndex,
          ) ??
          {};

      emit(
        AppEditorLoadedState(
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
    AppEditorSelectWidgetEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final widgetAttributes = _getWidgetAttributes(
            currentState.editorState,
            event.sectionType,
            event.layoutIndex,
            event.widgetIndex,
          ) ??
          {};

      emit(
        AppEditorLoadedState(
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
    AppEditorClearSelectionEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      emit(
        AppEditorLoadedState(
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
    AppEditorPageAttributesUpdated event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.pageAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorLoadedState(
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
    AppEditorSectionAttributesUpdated event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.sectionAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorLoadedState(
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
    AppEditorLayoutAttributesUpdated event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.layoutAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorLoadedState(
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
    AppEditorWidgetAttributesUpdated event,
    Emitter<AppEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppEditorLoadedState) {
      final updatedAttributes =
          Map<String, dynamic>.from(currentState.widgetAttributes)
            ..addAll(event.attributes);

      emit(
        AppEditorLoadedState(
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
    AppEditorSaveStateEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    try {
      await repository.saveEditorState(
        projectId: projectId,
        state: event.state,
      );
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadState(
    AppEditorLoadStateEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    try {
      final state = await repository.loadEditorState(projectId);
      final currentState = this.state;
      if (currentState is AppEditorLoadedState) {
        emit(
          AppEditorLoadedState(
            selectedPageId: currentState.selectedPageId,
            editorState: state,
            selectedSectionType: currentState.selectedSectionType,
            selectedLayoutIndex: currentState.selectedLayoutIndex,
            selectedWidgetIndex: currentState.selectedWidgetIndex,
            pageAttributes: currentState.pageAttributes,
            sectionAttributes: currentState.sectionAttributes,
            layoutAttributes: currentState.layoutAttributes,
            widgetAttributes: currentState.widgetAttributes,
          ),
        );
      }
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Map<String, dynamic>? _getSectionAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
  ) {
    print(
      'Fetching attributes for section: ${sectionType.name}',
    );
    return editorState?['sections']?[sectionType.name]?['attributes']
        as Map<String, dynamic>?;
  }

  Map<String, dynamic>? _getLayoutAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
    int layoutIndex,
  ) {
    print(
      'Fetching attributes for layout: ${sectionType.name}[$layoutIndex]',
    );
    try {
      return editorState?['sections']?[sectionType.name]?['layouts']
          ?[layoutIndex]?['attributes'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching layout attributes: $e');
      return null;
    }
  }

  Map<String, dynamic>? _getWidgetAttributes(
    Map<String, dynamic>? editorState,
    PageSectionType sectionType,
    int layoutIndex,
    int widgetIndex,
  ) {
    print(
      'Fetching attributes for widget: ${sectionType.name}[$layoutIndex][$widgetIndex]',
    );
    try {
      return editorState?['sections']?[sectionType.name]?['layouts']
              ?[layoutIndex]?['widgets']?[widgetIndex]?['attributes']
          as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching widget attributes: $e');
      return null;
    }
  }
}
