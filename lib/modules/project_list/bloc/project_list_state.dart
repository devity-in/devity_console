part of 'project_list_bloc.dart';

/// [ProjectListState] is a class that describes the state of the project list.
@freezed
class ProjectListState with _$ProjectListState {
  /// [ProjectListState] when the project list is initially loaded.
  const factory ProjectListState.initial() = _Initial;
}
