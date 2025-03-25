import 'package:devity_console/config/constants.dart';
import 'package:devity_console/modules/app_editor_component_list/view/app_editor_component_list.dart';
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
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Constants.appDividerColor,
            width: Constants.appDividerWidth,
          ),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.pages_outlined,
                  ),
                  text: 'Pages',
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                  ),
                  text: 'Components',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AppEditorPageList(),
              AppEditorComponentList(),
            ],
          ),
        ),
      ),
    );
  }
}
