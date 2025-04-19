import 'package:bloc/bloc.dart';

part 'app_editor_event.dart';
part 'app_editor_state.dart';

/// [AppEditorBloc] is a business logic component that manages the state of the
/// AppEditor widget.
class AppEditorBloc extends Bloc<AppEditorEvent, AppEditorState> {
  /// The default constructor for the [AppEditorBloc].
  AppEditorBloc() : super(const AppEditorInitialState()) {
    on<AppEditorStartedEvent>(_onStarted);
    on<AppEditorCreatePageEvent>(_onCreatePage);
    on<AppEditorUpdatePageEvent>(_onUpdatePage);
    on<AppEditorDeletePageEvent>(_onDeletePage);
    on<AppEditorSelectPageEvent>(_onSelectPage);
  }

  Future<void> _onStarted(
    AppEditorStartedEvent event,
    Emitter<AppEditorState> emit,
  ) async {
    emit(const AppEditorLoadingState());
    try {
      // TODO: Load pages from repository
      final pages = <AppPage>[];
      emit(AppEditorLoadedState(pages: pages));
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
      // TODO: Create page in repository
      final newPage = AppPage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
      );
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages = [...currentState.pages, newPage];
        emit(AppEditorLoadedState(
          pages: updatedPages,
          selectedPageId: currentState.selectedPageId,
        ));
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
      // TODO: Update page in repository
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages = currentState.pages.map((page) {
          if (page.id == event.id) {
            return AppPage(
              id: page.id,
              name: event.name,
              description: event.description,
            );
          }
          return page;
        }).toList();
        emit(AppEditorLoadedState(
          pages: updatedPages,
          selectedPageId: currentState.selectedPageId,
        ));
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
      // TODO: Delete page from repository
      final currentState = state;
      if (currentState is AppEditorLoadedState) {
        final updatedPages =
            currentState.pages.where((page) => page.id != event.id).toList();
        emit(AppEditorLoadedState(
          pages: updatedPages,
          selectedPageId: currentState.selectedPageId == event.id
              ? null
              : currentState.selectedPageId,
        ));
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
      emit(AppEditorLoadedState(
        pages: currentState.pages,
        selectedPageId: event.id,
      ));
    }
  }
}
