part of 'project_bloc.dart';

/// [ProjectState] is a class that describes the state of the [ProjectBloc].
@freezed
class ProjectState with _$ProjectState {
  /// The initial state of the [ProjectBloc].
  const factory ProjectState.initial() = _Initial;
}
