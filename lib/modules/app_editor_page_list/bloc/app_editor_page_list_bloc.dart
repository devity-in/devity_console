import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_page_list_event.dart';
part 'app_editor_page_list_state.dart';
part 'app_editor_page_list_bloc.freezed.dart';

/// [AppEditorPageListBloc] is a business logic component that manages the
/// state of the AppEditorPageList widget.
///
class AppEditorPageListBloc
    extends Bloc<AppEditorPageListEvent, AppEditorPageListState> {
  // In-memory storage for pages
  final List<Page> _pages = [];

  /// The default constructor for the [AppEditorPageListBloc].
  AppEditorPageListBloc() : super(const AppEditorPageListState.initial()) {
    on<_Started>(_onStarted);
    on<_AddPage>(_onAddPage);
    on<_DeletePage>(_onDeletePage);
  }

  void _onStarted(_Started event, Emitter<AppEditorPageListState> emit) {
    emit(const AppEditorPageListState.loading());
    try {
      emit(AppEditorPageListState.loaded(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListState.error(message: 'Failed to load pages: $e'));
    }
  }

  void _onAddPage(_AddPage event, Emitter<AppEditorPageListState> emit) {
    emit(const AppEditorPageListState.loading());
    try {
      final newPage = Page(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        createdAt: DateTime.now(),
      );
      _pages.add(newPage);
      emit(AppEditorPageListState.loaded(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListState.error(message: 'Failed to add page: $e'));
    }
  }

  void _onDeletePage(_DeletePage event, Emitter<AppEditorPageListState> emit) {
    emit(const AppEditorPageListState.loading());
    try {
      _pages.removeWhere((page) => page.id == event.pageId);
      emit(AppEditorPageListState.loaded(pages: List.from(_pages)));
    } catch (e) {
      emit(AppEditorPageListState.error(message: 'Failed to delete page: $e'));
    }
  }
}
