import 'package:devity_console/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [AppEditorAttributeEditor] is a StatelessWidget that displays
/// the app editor attribute editor.
class AppEditorAttributeEditor extends StatelessWidget {
  /// Creates a new instance of [AppEditorAttributeEditor].
  const AppEditorAttributeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Constants.appDividerColor,
            width: Constants.appDividerWidth,
          ),
        ),
      ),
    );
  }
}
