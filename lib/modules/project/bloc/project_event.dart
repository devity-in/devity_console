part of 'project_bloc.dart';

/// [ProjectEvent] is a class that describes the events that can be
/// triggered in the [ProjectBloc].
@freezed
class ProjectEvent with _$ProjectEvent {
  /// The event that is triggered when the [ProjectBloc] is started.
  const factory ProjectEvent.started() = _Started;
}
