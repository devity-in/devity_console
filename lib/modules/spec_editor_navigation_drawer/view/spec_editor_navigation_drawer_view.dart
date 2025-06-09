import 'package:devity_console/config/constants.dart';
import 'package:devity_console/modules/spec_editor_page_list/app_editor_page_list.dart';
import 'package:devity_console/modules/spec_editor_widget_list/view/app_editor_widget_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [SpecEditorNavigationDrawer] is a StatelessWidget that displays
/// the app editor navigation drawer.
class SpecEditorNavigationDrawer extends StatelessWidget {
  /// Creates a [SpecEditorNavigationDrawer].
  const SpecEditorNavigationDrawer({
    required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            width: UIConstants.appDividerWidth,
          ),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pages_outlined),
                      SizedBox(width: 8),
                      Text('Pages'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.widgets_outlined),
                      SizedBox(width: 8),
                      Text('Widgets'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AppEditorPageList(projectId: projectId),
                  AppEditorWidgetList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
