part of 'app_editor_bloc.dart';

@freezed
class AppEditorEvent with _$AppEditorEvent {
  const factory AppEditorEvent.started() = _Started;
}