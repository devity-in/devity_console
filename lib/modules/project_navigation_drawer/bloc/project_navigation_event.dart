part of 'project_navigation_bloc.dart';

/// [ProjectNavigationEvent] is a class that describes the events that can be
/// triggered in the [ProjectNavigationBloc].
@freezed
abstract class ProjectNavigationEvent with _$ProjectNavigationEvent {
  /// The event that is triggered when the [ProjectNavigationBloc] is started.
  const factory ProjectNavigationEvent.started() = _Started;

  /// The event that is triggered when the [ProjectNavigationBloc] want
  /// to reload the data.
  const factory ProjectNavigationEvent.reload() = _Reload;
}
