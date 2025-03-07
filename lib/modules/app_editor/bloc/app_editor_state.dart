part of 'app_editor_bloc.dart';

/// The [AppEditorState] is a class that describes the different states that the
/// AppEditor widget can be in.
@freezed
class AppEditorState with _$AppEditorState {
  /// The initial state of the AppEditor widget.
  const factory AppEditorState.initial() = _Initial;
}
