part of 'project_navigation_bloc.dart';

/// [ProjectNavigationState] is a class that describes the state of the
/// [ProjectNavigationBloc].
@freezed
abstract class ProjectNavigationState with _$ProjectNavigationState {
  /// The initial state of the [ProjectNavigationBloc].
  const factory ProjectNavigationState.initial() = _Initial;

  /// The loaded state of the navigation drawer.
  const factory ProjectNavigationState.loaded(
    List<ProjectNavigationDrawerItem> items,
    ProjectNavigationDrawerItem? selectedItem, {
    @Default(false) bool isExpanded,
  }) = Loaded;
}
