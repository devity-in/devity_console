part of 'project_navigation_bloc.dart';

@freezed
class ProjectNavigationEvent with _$ProjectNavigationEvent {
  const factory ProjectNavigationEvent.started() = _Started;
}