import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_action_bar/spec_editor_action_bar.dart';
import 'package:devity_console/modules/spec_editor_attribute_editor/spec_editor_attribute_editor.dart';
import 'package:devity_console/modules/spec_editor_navigation_drawer/spec_editor_navigation_drawer.dart';
import 'package:devity_console/modules/spec_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/spec_editor_page_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// [SpecEditor] is a provider widget that sets up the [SpecEditorBloc]
/// and provides it to its children.
class SpecEditor extends StatelessWidget {
  /// Constructor
  const SpecEditor({
    required this.projectId,
    super.key,
  });

  /// The ID of the project to edit.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecEditorBloc(projectId: projectId)
        ..add(const SpecEditorStartedEvent()),
      child: const SpecEditorView(),
    );
  }
}

/// [SpecEditorView] is a StatelessWidget that displays the app editor UI.
class SpecEditorView extends StatelessWidget {
  /// Constructor
  const SpecEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppEditorPageEditorBloc>(
      create: (context) => AppEditorPageEditorBloc()
        ..add(const AppEditorPageEditorInitialized()),
      child: BlocBuilder<SpecEditorBloc, SpecEditorState>(
        builder: (context, state) {
          return Material(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(10.h),
                child: const SpecEditorActionBar(),
              ),
              body: Row(
                children: [
                  const SpecEditorNavigationDrawer(),
                  Expanded(
                    child: state is SpecEditorLoadedState &&
                            state.selectedPageId != null
                        ? const SpecEditorPageEditor()
                        : const Center(
                            child: Text('Select a page to edit'),
                          ),
                  ),
                  const SpecEditorAttributeEditor(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
