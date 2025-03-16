import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/project_navigation_drawer/models/project_navigation_drawer_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_navigation_event.dart';
part 'project_navigation_state.dart';
part 'project_navigation_bloc.freezed.dart';

/// [ProjectNavigationBloc] is a business logic component that manages the state
/// of the ProjectNavigation widget.
class ProjectNavigationBloc
    extends Bloc<ProjectNavigationEvent, ProjectNavigationState> {
  /// The default constructor for the [ProjectNavigationBloc].
  ProjectNavigationBloc() : super(const _Initial()) {
    on<_Started>(
      (event, emit) => emit(
        Loaded(
          _projectNavigationDrawerItems,
          _selectedItem,
        ),
      ),
    );
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
    ProjectNavigationDrawerItem(
      title: 'Application editor',
      route: '/application-editor',
      icon: Icons.menu,
    ),
  ];
}
