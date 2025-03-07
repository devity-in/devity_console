part of 'app_editor_attribute_editor_bloc.dart';

/// The [AppEditorAttributeEditorState] is a class that describes the different
/// states that the AppEditorAttributeEditor widget can be in.
@freezed
class AppEditorAttributeEditorState with _$AppEditorAttributeEditorState {
  /// The initial state of the AppEditorAttributeEditor widget.
  const factory AppEditorAttributeEditorState.initial() = _Initial;
}
