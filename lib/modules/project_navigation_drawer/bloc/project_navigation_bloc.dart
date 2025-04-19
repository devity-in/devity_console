import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/project_navigation_drawer/models/project_navigation_drawer_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;

part 'project_navigation_event.dart';
part 'project_navigation_state.dart';

/// [ProjectNavigationBloc] is a business logic component that manages the state
/// of the ProjectNavigation widget.
class ProjectNavigationBloc
    extends Bloc<ProjectNavigationEvent, ProjectNavigationState> {
  /// The default constructor for the [ProjectNavigationBloc].
  ProjectNavigationBloc() : super(const ProjectNavigationInitialState()) {
    on<ProjectNavigationStartedEvent>(_onStarted);
    on<ProjectNavigationReloadEvent>(_onReload);
  }

  ProjectNavigationDrawerItem? _selectedItem;
  static const _projectNavigationDrawerItems = [
    ProjectNavigationDrawerItem(
      title: 'Component builder',
      route: '/component-builder',
      icon: Icons.dashboard,
    ),
    ProjectNavigationDrawerItem(
      title: 'Data factory',
      route: '/data-factory',
      icon: Icons.stacked_bar_chart,
    ),
    ProjectNavigationDrawerItem(
      title: 'Application editor',
      route: '/application-editor',
      icon: Icons.menu,
    ),
  ];

  Future<void> _onStarted(
    ProjectNavigationStartedEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    emit(const ProjectNavigationLoadingState());
    try {
      emit(ProjectNavigationLoadedState(
        items: _projectNavigationDrawerItems,
        selectedItem: _selectedItem,
      ));
    } catch (e) {
      emit(ProjectNavigationErrorState(message: e.toString()));
    }
  }

  Future<void> _onReload(
    ProjectNavigationReloadEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    emit(const ProjectNavigationLoadingState());
    try {
      emit(ProjectNavigationLoadedState(
        items: _projectNavigationDrawerItems,
        selectedItem: _selectedItem,
      ));
    } catch (e) {
      emit(ProjectNavigationErrorState(message: e.toString()));
    }
  }
}
