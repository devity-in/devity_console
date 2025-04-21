import 'package:devity_console/models/project.dart';
import 'package:devity_console/widgets/desktop_basic_widgets.dart';
import 'package:flutter/material.dart';

/// Widget for the project list search bar
class ProjectListSearchBar extends StatelessWidget {
  /// Constructor
  const ProjectListSearchBar({
    required this.onSearchChanged,
    super.key,
  });

  /// Callback when search text changes
  final void Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return DesktopTextEditor(
      title: 'Search Projects',
      onChanged: onSearchChanged,
      suffixIconWidget: const Icon(Icons.search),
    );
  }
}

/// Widget for the project list add button
class ProjectListAddButton extends StatelessWidget {
  /// Constructor
  const ProjectListAddButton({
    required this.onPressed,
    super.key,
  });

  /// Callback when button is pressed
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DesktopElevatedButton(
      title: 'Add Project',
      onPressed: onPressed,
    );
  }
}

/// Widget for a single project card
class ProjectCard extends StatelessWidget {
  /// Constructor
  const ProjectCard({
    required this.project,
    required this.onTap,
    super.key,
  });

  /// The project to display
  final Project project;

  /// Callback when card is tapped
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (project.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  project.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Created: ${project.createdAt.toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for the project list grid
class ProjectListGrid extends StatelessWidget {
  /// Constructor
  const ProjectListGrid({
    required this.projects,
    required this.onProjectTap,
    super.key,
  });

  /// List of projects to display
  final List<Project> projects;

  /// Callback when a project is tapped
  final void Function(Project) onProjectTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          project: project,
          onTap: () => onProjectTap(project),
        );
      },
    );
  }
}
