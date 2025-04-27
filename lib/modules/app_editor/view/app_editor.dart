import 'package:devity_console/modules/app_editor/bloc/app_editor_bloc.dart';
import 'package:devity_console/modules/app_editor_action_bar/app_editor_action_bar.dart';
import 'package:devity_console/modules/app_editor_attribute_editor/app_editor_attribute_editor.dart';
import 'package:devity_console/modules/app_editor_navigation_drawer/app_editor_navigation_drawer.dart';
import 'package:devity_console/modules/app_editor_page_editor/app_editor_page_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// [AppEditor] is a provider widget that sets up the [AppEditorBloc]
/// and provides it to its children.
class AppEditor extends StatelessWidget {
  /// Constructor
  const AppEditor({
    required this.projectId,
    super.key,
  });

  /// The ID of the project to edit.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorBloc(projectId: projectId)
        ..add(const AppEditorStartedEvent()),
      child: const AppEditorView(),
    );
  }
}

/// [AppEditorView] is a StatelessWidget that displays the app editor UI.
class AppEditorView extends StatelessWidget {
  /// Constructor
  const AppEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppEditorBloc, AppEditorState>(
      builder: (context, state) {
        return Material(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(10.h),
              child: const AppEditorActionBar(),
            ),
            body: Row(
              children: [
                const AppEditorNavigationDrawer(),
                Expanded(
                  child: state is AppEditorLoadedState &&
                          state.selectedPageId != null
                      ? const AppEditorPageEditor()
                      : const Center(
                          child: Text('Select a page to edit'),
                        ),
                ),
                const AppEditorAttributeEditor(),
              ],
            ),
          ),
        );
      },
    );
  }
}
