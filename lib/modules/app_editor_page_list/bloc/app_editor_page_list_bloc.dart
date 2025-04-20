import 'package:bloc/bloc.dart';

part 'app_editor_page_list_event.dart';
part 'app_editor_page_list_state.dart';

/// [AppEditorPageListBloc] is a business logic component that manages the
/// state of the AppEditorPageList widget.
///
class AppEditorPageListBloc
    extends Bloc<AppEditorPageListEvent, AppEditorPageListState> {
  /// The default constructor for the [AppEditorPageListBloc].
  AppEditorPageListBloc() : super(const AppEditorPageListInitialState()) {
    on<AppEditorPageListStartedEvent>(_onStarted);
    on<AppEditorPageListAddPageEvent>(_onAddPage);
    on<AppEditorPageListDeletePageEvent>(_onDeletePage);
  }
  // In-memory storage for pages
  final List<Page> _pages = [];

  Future<void> _onStarted(
    AppEditorPageListStartedEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    emit(const AppEditorPageListLoadingState());
    try {
      emit(AppEditorPageListLoadedState(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: 'Failed to load pages: $e'));
    }
  }

  Future<void> _onAddPage(
    AppEditorPageListAddPageEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    emit(const AppEditorPageListLoadingState());
    try {
      final newPage = Page(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        createdAt: DateTime.now(),
      );
      _pages.add(newPage);
      emit(AppEditorPageListLoadedState(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: 'Failed to add page: $e'));
    }
  }

  Future<void> _onDeletePage(
    AppEditorPageListDeletePageEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    emit(const AppEditorPageListLoadingState());
    try {
      _pages.removeWhere((page) => page.id == event.pageId);
      emit(AppEditorPageListLoadedState(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: 'Failed to delete page: $e'));
    }
  }
}
