import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:devity_console/modules/action_builder/view/action_builder_screen.dart';
import 'package:devity_console/modules/data_factory/view/data_factory_screen.dart';
import 'package:devity_console/modules/marketing_campaigns/view/marketing_campaigns_screen.dart';
import 'package:devity_console/modules/media_factory/view/media_factory_screen.dart';
import 'package:devity_console/modules/project_detail/bloc/project_detail_bloc.dart';
import 'package:devity_console/modules/project_navigation_drawer/project_navigation_drawer.dart';
import 'package:devity_console/modules/project_overview/view/project_overview_screen.dart';
import 'package:devity_console/modules/project_settings/view/project_settings_screen.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor/spec_editor.dart';
import 'package:devity_console/modules/widget_builder/view/widget_builder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProjectDetailScreen] is a StatelessWidget that displays a project.
/// It will have project navigation view i.e ProjectDrawer
/// to navigate within project.
/// It will have different views based on navigation selection.
class ProjectDetailScreen extends StatelessWidget {
  /// Creates a [ProjectDetailScreen].
  const ProjectDetailScreen({
    required this.projectId,
    super.key,
  });

  /// The ID of the project to display.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ProjectDetailView(
      projectId: projectId,
    );
  }
}

/// [ProjectDetailView] is a StatelessWidget that displays the project view.
class ProjectDetailView extends StatelessWidget {
  /// Creates a new instance of [ProjectDetailView].
  const ProjectDetailView({
    required this.projectId,
    super.key,
  });

  /// The ID of the project.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
      builder: (context, state) {
        if (state is ProjectDetailLoadedState) {
          return BlocProvider<SpecEditorBloc>(
            create: (_) => SpecEditorBloc(projectId: projectId)
              ..add(const SpecEditorStartedEvent()),
            child: Row(
              children: [
                ProjectNavigationDrawer(
                  projectId: projectId,
                  onItemSelected: (item) {
                    context
                        .read<ProjectDetailBloc>()
                        .add(ProjectDetailItemSelectedEvent(item: item));
                  },
                ),
                Expanded(
                  child: _buildSelectedView(
                    context,
                    state.selectedItem,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink(); // Handle loading/error states better?
      },
    );
  }

  Widget _buildSelectedView(
    BuildContext context,
    ProjectNavigationDrawerItem selectedItem,
  ) {
    return Builder(
      builder: (context) {
        switch (selectedItem.route) {
          case '/overview':
            return const ProjectOverviewScreen();
          case '/widget-builder':
            return const WidgetBuilderScreen();
          case '/data-factory':
            return const DataFactoryScreen();
          case '/app-editor': // Route name vs actual module name
            return SpecEditor(projectId: projectId);
          case '/action-builder':
            return ActionBuilderScreen(projectId: projectId);
          case '/media-factory':
            return const MediaFactoryScreen();
          case '/marketing-campaigns':
            return const MarketingCampaignsScreen();
          case '/settings':
            return const ProjectSettingsScreen();
          default:
            return const Center(child: Text('Select an item from the drawer'));
        }
      },
    );
  }
}
