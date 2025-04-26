import 'package:flutter/widgets.dart' show IconData;

/// [ProjectNavigationDrawerItem] is a class that represents a
/// project navigation drawer item.
class ProjectNavigationDrawerItem {
  /// Creates a new instance of [ProjectNavigationDrawerItem].
  const ProjectNavigationDrawerItem({
    required this.id,
    required this.title,
    required this.route,
    required this.icon,
    required this.projectId,
  });

  /// Creates an empty instance of [ProjectNavigationDrawerItem].
  factory ProjectNavigationDrawerItem.empty() =>
      const ProjectNavigationDrawerItem(
        id: '',
        title: '',
        route: '',
        icon: null,
        projectId: '',
      );

  /// The unique identifier of the navigation item
  final String id;

  /// The title of the navigation item
  final String title;

  /// The route of the navigation item
  final String route;

  /// The icon of the navigation item
  final IconData? icon;

  /// The project ID associated with this navigation item
  final String projectId;
}
