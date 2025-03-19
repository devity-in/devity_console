import 'package:devity_console/config/constants.dart';
import 'package:devity_console/widgets/desktop_basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// [AppEditorActionBar] is a StatelessWidget that displays
/// the app editor action bar.
class AppEditorActionBar extends StatelessWidget {
  /// Creates a new instance of [AppEditorActionBar].s
  const AppEditorActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Constants.appDividerColor,
            width: Constants.appDividerWidth,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "My App",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.app_settings_alt),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.mobile_friendly),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "375 x 667",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Icon(Icons.cloud_sync),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Last saved",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "2 days ago",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              DesktopOutlinedButton(title: 'SAVE', onPressed: () {}),
              const SizedBox(width: 10),
              DesktopElevatedButton(title: 'PUBLISH', onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}
