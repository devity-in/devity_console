import 'package:devity_console/modules/app_editor/app_editor.dart';
import 'package:devity_console/modules/project_navigation_drawer/project_navigation_drawer.dart';
import 'package:flutter/material.dart';

/// [ProjectView] is a StatelessWidget that displays a project.
/// It will have project navigation view i.e ProjectDrawer
/// to navigate within project.
/// It will have AppEditorView to edit the app design.
class ProjectView extends StatelessWidget {
  /// Creates a [ProjectView].
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    /// It will consist of ProjectDrawer and AppEditorView.
    return const Row(
      children: [
        ProjectNavigationDrawer(),
        Expanded(
          child: AppEditor(),
        ),
      ],
    );
  }
}
