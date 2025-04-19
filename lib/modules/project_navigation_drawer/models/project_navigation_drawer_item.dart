import 'package:flutter/widgets.dart' show IconData;

/// [ProjectNavigationDrawerItem] is a class that represents a
/// project navigation drawer item.
class ProjectNavigationDrawerItem {
  /// Creates a new instance of [ProjectNavigationDrawerItem].
  const ProjectNavigationDrawerItem({
    required this.title,
    required this.route,
    required this.icon,
  });

  /// Creates an empty instance of [ProjectNavigationDrawerItem].
  factory ProjectNavigationDrawerItem.empty() =>
      const ProjectNavigationDrawerItem(
        title: '',
        route: '',
        icon: null,
      );

  final String title;
  final String route;
  final IconData? icon;
}
