import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/widgets/default_add_widget.dart';
import 'package:devity_console/modules/spec_editor_page_editor/widgets/mobile_phone_mockup_widget.dart';
// Import SDK components
import 'package:devity_sdk/devity_sdk.dart';
import 'package:devity_sdk/models/spec_model.dart' hide ScreenModel;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [SpecEditorPageEditor] is a StatelessWidget that provides
/// the app editor page editor bloc.
class SpecEditorPageEditor extends StatelessWidget {
  /// Creates a new instance of [SpecEditorPageEditor].
  const SpecEditorPageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider removed from here
    return const SpecEditorPageEditorView();
  }
}

/// [SpecEditorPageEditorView] is a StatelessWidget that displays
/// the app editor page editor with drag and drop support.
class SpecEditorPageEditorView extends StatelessWidget {
  /// Creates a new instance of [SpecEditorPageEditorView].
  const SpecEditorPageEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to AppEditorPageEditorBloc for selection changes if needed for overlays later
    // For now, primary data comes from SpecEditorBloc

    // Get spec data from SpecEditorBloc
    final specState = context.watch<SpecEditorBloc>().state;
    // Get editor state from AppEditorPageEditorBloc for selectedElementId
    final editorState = context.watch<AppEditorPageEditorBloc>().state;

    const pageBackgroundColor = Colors.white; // Default, remove const var
    DevitySpec? parsedSpec;
    ScreenModel? currentScreenModel;

    if (specState is SpecEditorLoadedState) {
      try {
        print('specState.specData: ${specState.specData}');
        // Parse the full spec
        parsedSpec = DevitySpec.fromJson(
          Map<String, dynamic>.from(specState.specData),
        );
        final selectedPageId = specState.selectedPageId;
        print('parsedSpec: $parsedSpec');
        if (selectedPageId != null &&
            parsedSpec.screens.containsKey(selectedPageId)) {
          currentScreenModel = parsedSpec.screens[selectedPageId];
          // TODO: Implement color parsing
        } else {
          // Handle case where selected page ID is invalid or not found
          currentScreenModel = null;
        }
      } catch (e) {
        print('Error parsing spec: $e');
        // Handle parsing error - show error message?
        parsedSpec = null;
        currentScreenModel = null;
      }
    } else {
      // Handle non-loaded states (show loading or error)
      return const Center(child: CircularProgressIndicator());
    }

    // Main UI structure mimicking a phone
    return MobilePhoneMockupWidget(
      child: Column(
        children: [
          // Top Renderer [ Widgets are organised vertically one by one]
          Column(
            children: [
              // Default Area for adding widgets
              DefaultAddWidget(
                onAddWidget: (widget) {
                  print('Adding widget: $widget');
                },
              ),
            ],
          ),
          // Main Renderer [ Widgets are organised vertically and becomes scrollable]
          Expanded(
            child: Column(
              children: [
                // Default Area for adding widgets
                DefaultAddWidget(
                  onAddWidget: (widget) {
                    print('Adding widget: $widget');
                  },
                ),
              ],
            ),
          ),
          // Bottom Renderer [ Widgets are organised vertically and sticked to bottom ]
          Column(
            children: [
              // Default Area for adding widgets
              DefaultAddWidget(
                onAddWidget: (widget) {
                  print('Adding widget: $widget');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
