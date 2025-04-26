import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [ProjectNavigationDrawerExpandedWidget] is a StatelessWidget that displays
/// the expanded project navigation drawer item.
class ProjectNavigationDrawerExpandedWidget extends StatelessWidget {
  /// Creates a new instance of [ProjectNavigationDrawerExpandedWidget].
  const ProjectNavigationDrawerExpandedWidget({
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
      width: 24.w,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item.id == selectedItem.id;

            return Material(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : Colors.transparent,
              child: InkWell(
                onTap: () => onItemTap(item),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.5.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 2.5.h,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 1.8.h,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
