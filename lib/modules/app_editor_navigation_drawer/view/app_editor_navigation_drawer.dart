import 'package:devity_console/config/constants.dart';
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
    );
  }
}
