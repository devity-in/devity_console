part of 'project_list_bloc.dart';

/// [ProjectListEvent] is a class that describes the events that can be
/// triggered in the [ProjectListBloc].
@freezed
class ProjectListEvent with _$ProjectListEvent {
  /// The event that is triggered when the [ProjectListBloc] is started.
  const factory ProjectListEvent.started() = _Started;
}
