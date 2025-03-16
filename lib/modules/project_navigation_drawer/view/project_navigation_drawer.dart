import 'package:devity_console/modules/project_navigation_drawer/bloc/project_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProjectNavigationDrawer] is a StatelessWidget
/// that displays a project navigation drawer.
class ProjectNavigationDrawer extends StatelessWidget {
  /// Constructor
  const ProjectNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectNavigationBloc(),
      child: BlocBuilder<ProjectNavigationBloc, ProjectNavigationState>(
        builder: (context, state) {
          if (state is Loaded) {
            final items = state.items;
            return AnimatedContainer(
              duration: Duration.zero,
              child: Column(
                children: items.map((item) => Icon(item.icon)).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
