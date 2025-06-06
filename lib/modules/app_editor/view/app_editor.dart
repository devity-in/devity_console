import 'package:devity_console/modules/app_editor_action_bar/app_editor_action_bar.dart';
import 'package:devity_console/modules/app_editor_attribute_editor/app_editor_attribute_editor.dart';
import 'package:devity_console/modules/app_editor_navigation_drawer/app_editor_navigation_drawer.dart';
import 'package:devity_console/modules/app_editor_page_editor/app_editor_page_editor.dart';
import 'package:flutter/material.dart';

/// [AppEditor] is a StatelessWidget that displays the app editor.
class AppEditor extends StatelessWidget {
  /// Constructor
  const AppEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppEditorActionBar(),
        Row(
          children: [
            AppEditorNavigationDrawer(),
            Expanded(
              child: AppEditorPageEditor(),
            ),
            AppEditorAttributeEditor(),
          ],
        ),
      ],
    );
  }
}
