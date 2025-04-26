import 'package:devity_console/config/constants.dart';
import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:devity_console/modules/project_navigation_drawer/bloc/project_navigation_bloc.dart';
import 'package:devity_console/modules/project_navigation_drawer/widgets/project_navigation_drawer_collapsed_item.dart';
import 'package:devity_console/modules/project_navigation_drawer/widgets/project_navigation_drawer_expanded_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// [ProjectNavigationDrawer] is a StatelessWidget that displays the project
/// navigation drawer.
class ProjectNavigationDrawer extends StatelessWidget {
  /// Creates a new instance of [ProjectNavigationDrawer].
  const ProjectNavigationDrawer({
    required this.projectId,
    required this.onItemSelected,
    super.key,
  });

  /// The ID of the project.
  final String projectId;

  /// Callback when an item is selected.
  final void Function(ProjectNavigationDrawerItem item) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectNavigationBloc()
        ..add(ProjectNavigationStartedEvent(projectId: projectId)),
      child: const ProjectNavigationDrawerView(),
    );
  }
}

/// [ProjectNavigationDrawerView] is a StatelessWidget that displays the project
/// navigation drawer view.
class ProjectNavigationDrawerView extends StatelessWidget {
  /// Creates a new instance of [ProjectNavigationDrawerView].
  const ProjectNavigationDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return BlocBuilder<ProjectNavigationBloc, ProjectNavigationState>(
      builder: (context, state) {
        if (state is ProjectNavigationLoadedState) {
          final items = state.items;
          final isExpanded = state.isExpanded;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.2),
                  width: UIConstants.appDividerWidth,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: isExpanded
                      ? ProjectNavigationDrawerExpandedWidget(
                          items: items,
                          selectedItem: state.selectedItem,
                          onItemTap: (item) {
                            final parent =
                                context.findAncestorWidgetOfExactType<
                                    ProjectNavigationDrawer>();
                            parent?.onItemSelected(item);
                            context.read<ProjectNavigationBloc>().add(
                                  ProjectNavigationItemSelectedEvent(
                                    item: item,
                                  ),
                                );
                          },
                        )
                      : ProjectNavigationDrawerCollapsedWidget(
                          items: items,
                          selectedItem: state.selectedItem,
                          onItemTap: (item) {
                            final parent =
                                context.findAncestorWidgetOfExactType<
                                    ProjectNavigationDrawer>();
                            parent?.onItemSelected(item);
                            context.read<ProjectNavigationBloc>().add(
                                  ProjectNavigationItemSelectedEvent(
                                    item: item,
                                  ),
                                );
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                        width: UIConstants.appDividerWidth,
                      ),
                    ),
                  ),
                  child: Material(
                    color: colorScheme.surface,
                    child: InkWell(
                      onTap: () {
                        context.read<ProjectNavigationBloc>().add(
                              const ProjectNavigationToggleExpandedEvent(),
                            );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),
                        child: Icon(
                          isExpanded
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: 2.5.h,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
