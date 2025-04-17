part of 'app_editor_page_list_bloc.dart';

/// [AppEditorPageListState] is a class that describes the state of the
/// AppEditorPageList widget.
@freezed
abstract class AppEditorPageListState with _$AppEditorPageListState {
  /// The initial state of the AppEditorPageList widget.
  const factory AppEditorPageListState.initial() = _Initial;

  /// The loading state of the AppEditorPageList widget.
  const factory AppEditorPageListState.loading() = Loading;

  /// The loaded state of the AppEditorPageList widget.
  const factory AppEditorPageListState.loaded({
    required List<Page> pages,
  }) = Loaded;

  /// The error state of the AppEditorPageList widget.
  const factory AppEditorPageListState.error({
    required String message,
  }) = Error;
}

/// [Page] is a class that represents a page in the AppEditorPageList widget.
@freezed
abstract class Page with _$Page {
  /// Creates a new instance of [Page].
  const factory Page({
    required String id,
    required String name,
    required String description,
    required DateTime createdAt,
  }) = _Page;
}
