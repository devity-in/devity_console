import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [ProjectNavigationDrawerCollapsedWidget] is a StatelessWidget that displays
/// the collapsed project navigation drawer item.
class ProjectNavigationDrawerCollapsedWidget extends StatelessWidget {
  /// Creates a new instance of [ProjectNavigationDrawerCollapsedWidget].
  const ProjectNavigationDrawerCollapsedWidget({
    required this.items,
    required this.onItemTap,
    required this.selectedItem,
    super.key,
  });

  /// The list of navigation items.
  final List<ProjectNavigationDrawerItem> items;

  /// Callback when an item is tapped.
  final void Function(ProjectNavigationDrawerItem item) onItemTap;

  /// The currently selected item.
  final ProjectNavigationDrawerItem selectedItem;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 8.w,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.id == selectedItem.id;

          return Material(
            color:
                isSelected ? colorScheme.primaryContainer : Colors.transparent,
            child: InkWell(
              onTap: () => onItemTap(item),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 1.5.h,
                ),
                child: Icon(
                  item.icon,
                  size: 2.5.h,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
