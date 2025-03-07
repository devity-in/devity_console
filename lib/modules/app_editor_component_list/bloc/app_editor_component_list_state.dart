part of 'app_editor_component_list_bloc.dart';

/// The [AppEditorComponentListState] is a class that describes the different
/// states that the AppEditorComponentList widget can be in.
@freezed
class AppEditorComponentListState with _$AppEditorComponentListState {
  /// The initial state of the AppEditorComponentList widget.
  const factory AppEditorComponentListState.initial() = _Initial;
}
