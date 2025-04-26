import 'package:devity_console/config/constants.dart';
import 'package:devity_console/modules/app_editor_widget_list/view/app_editor_widget_list.dart';
import 'package:devity_console/modules/app_editor_page_list/app_editor_page_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [AppEditorNavigationDrawer] is a StatelessWidget that displays
/// the app editor navigation drawer.
class AppEditorNavigationDrawer extends StatelessWidget {
  /// Creates a [AppEditorNavigationDrawer].
  const AppEditorNavigationDrawer({super.key});

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
      child: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.pages_outlined),
                  text: 'Pages',
                ),
                Tab(
                  icon: Icon(Icons.widgets_outlined),
                  text: 'Widgets',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AppEditorPageList(),
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
