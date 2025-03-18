import 'package:devity_console/modules/project_navigation_drawer/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [ProjectNavigationDrawerExpandedWidget] is a StatelessWidget that displays
/// a project navigation drawer expanded item.
class ProjectNavigationDrawerExpandedWidget extends StatelessWidget {
  /// Creates a const [ProjectNavigationDrawerExpandedWidget].
  const ProjectNavigationDrawerExpandedWidget({
    required this.items,
    super.key,
    this.selectedItem,
  });

  /// [items] is a list of project navigation drawer items.
  final List<ProjectNavigationDrawerItem> items;

  /// [selectedItem] is the selected project navigation drawer item.
  final ProjectNavigationDrawerItem? selectedItem;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      child: Column(
        children: items
            .map(
              (item) => Row(
                children: [
                  Text(item.title),
                  Icon(item.icon),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
