part of 'project_navigation_bloc.dart';

/// [ProjectNavigationEvent] is a class that describes the events that can be
/// triggered in the [ProjectNavigationBloc].
@freezed
class ProjectNavigationEvent with _$ProjectNavigationEvent {
  /// The event that is triggered when the [ProjectNavigationBloc] is started.
  const factory ProjectNavigationEvent.started() = _Started;
}
