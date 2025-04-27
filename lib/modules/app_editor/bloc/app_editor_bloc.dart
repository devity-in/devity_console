import 'package:bloc/bloc.dart';
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
          ),
        );
      }
    } catch (e) {
      emit(AppEditorErrorState(message: e.toString()));
    }
  }
}
