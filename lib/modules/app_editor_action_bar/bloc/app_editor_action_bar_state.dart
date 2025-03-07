part of 'app_editor_action_bar_bloc.dart';

/// The [AppEditorActionBarState] is a class that describes the different states
/// that the AppEditorActionBar widget can be in.
@freezed
class AppEditorActionBarState with _$AppEditorActionBarState {
  /// The initial state of the AppEditorActionBar widget.
  const factory AppEditorActionBarState.initial() = _Initial;
}
