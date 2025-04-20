import 'package:bloc/bloc.dart';

part 'app_editor_page_editor_event.dart';
part 'app_editor_page_editor_state.dart';

/// [AppEditorPageEditorBloc] is a business logic component that manages the
/// state of the AppEditorPageEditor widget.
class AppEditorPageEditorBloc
    extends Bloc<AppEditorPageEditorEvent, AppEditorPageEditorState> {
  /// [AppEditorPageEditorBloc] constructor
  AppEditorPageEditorBloc() : super(const AppEditorPageEditorInitialState()) {
    on<AppEditorPageEditorStartedEvent>(_onStarted);
  }

  Future<void> _onStarted(
    AppEditorPageEditorStartedEvent event,
    Emitter<AppEditorPageEditorState> emit,
  ) async {
    emit(const AppEditorPageEditorLoadingState());
    try {
      emit(const AppEditorPageEditorLoadedState());
    } catch (e) {
      emit(AppEditorPageEditorErrorState(message: e.toString()));
    }
  }
}
