import 'package:bloc/bloc.dart';
import 'package:devity_console/repositories/app_editor_repository.dart';

part 'app_editor_event.dart';
part 'app_editor_state.dart';

/// [AppEditorBloc] is a business logic component that manages the state of the
/// AppEditor widget.
class AppEditorBloc extends Bloc<AppEditorEvent, AppEditorState> {
  /// The default constructor for the [AppEditorBloc].
  AppEditorBloc({
    required this.repository,
    required this.projectId,
  }) : super(const AppEditorInitialState()) {
    on<AppEditorStartedEvent>(_onStarted);
    on<AppEditorCreatePageEvent>(_onCreatePage);
    on<AppEditorUpdatePageEvent>(_onUpdatePage);
    on<AppEditorDeletePageEvent>(_onDeletePage);
    on<AppEditorSelectPageEvent>(_onSelectPage);
    on<AppEditorSaveStateEvent>(_onSaveState);
    on<AppEditorLoadStateEvent>(_onLoadState);
  }

  final AppEditorRepository repository;
  final String projectId;

  Future<void> _onStarted(
    AppEditorStartedEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      final pages = await repository.loadPages(projectId);
      emit(
        AppEditorLoadedState(
          pages: pages
              .map(
                (p) => AppPage(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreatePage(
    AppEditorCreatePageEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      final page = await repository.createPage(
        projectId: projectId,
        name: event.name,
        description: event.description,
      );
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages = [
          ...currentState.pages,
          AppPage(
            id: page.id,
            name: page.name,
            description: page.description,
          ),
        ];
        emit(
          AppEditorLoadedState(
            pages: updatedPages,
            selectedPageId: currentState.selectedPageId,
          ),
        );
      }
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdatePage(
    AppEditorUpdatePageEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      final page = await repository.updatePage(
        projectId: projectId,
        pageId: event.id,
        name: event.name,
        description: event.description,
      );
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages = currentState.pages.map((p) {
          if (p.id == event.id) {
            return AppPage(
              id: page.id,
              name: page.name,
              description: page.description,
            );
          }
          return p;
        }).toList();
        emit(
          AppEditorLoadedState(
            pages: updatedPages,
            selectedPageId: currentState.selectedPageId,
          ),
        );
      }
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeletePage(
    AppEditorDeletePageEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      await repository.deletePage(
        projectId: projectId,
        pageId: event.id,
      );
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages =
            currentState.pages.where((page) => page.id != event.id).toList();
        emit(
          AppEditorLoadedState(
            pages: updatedPages,
            selectedPageId: currentState.selectedPageId == event.id
                ? null
                : currentState.selectedPageId,
          ),
        );
      }
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
          pages: currentState.pages,
          selectedPageId: event.id,
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
            pages: currentState.pages,
            selectedPageId: currentState.selectedPageId,
            editorState: state,
          ),
        );
      }
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }
}
