import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
// Import SDK components
import 'package:devity_sdk/devity_sdk.dart';
import 'package:devity_sdk/models/spec_model.dart' hide ScreenModel;
import 'package:devity_sdk/providers/action_service_provider.dart';
import 'package:devity_sdk/services/action_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [SpecEditorPageEditor] is a StatelessWidget that provides
/// the app editor page editor bloc.
class SpecEditorPageEditor extends StatelessWidget {
  /// Creates a new instance of [SpecEditorPageEditor].
  const SpecEditorPageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorPageEditorBloc()
        ..add(const AppEditorPageEditorInitialized()),
      child: const SpecEditorPageEditorView(),
    );
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
        // Parse the full spec
        parsedSpec = DevitySpec.fromJson(specState.specData);
        final selectedPageId = specState.selectedPageId;

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

    // Correct dummy handler signature
    void dummyNavHandler(String screenId) {
      print('[Preview Navigate] Screen ID: $screenId');
      // Avoid using context directly inside the handler definition if possible,
      // or ensure it's the correct context when called.
      // For a simple preview snackbar, this might be okay, but risky.
      if (context.mounted) {
        // Check context validity
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('[Preview] Navigate to screen: $screenId')),
        );
      }
    }

    // Correct ActionService instantiation (positional spec) and fallback spec
    final previewActionService = ActionService(
      parsedSpec ??
          const DevitySpec(
            specVersion: 'error',
            specId: 'error',
            version: 0,
            entryPoint: '',
          ),
      navigationHandler: dummyNavHandler,
    );

    // Main UI structure mimicking a phone
    return Center(
      child: Container(
        width: 375, // iPhone width
        height: 812, // iPhone height
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey[800]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Scaffold(
            // Use background color from spec if available
            backgroundColor: pageBackgroundColor,
            body: Column(
              children: [
                // Status Bar
                Container(
                  height: 44,
                  color: Colors.black,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 60),
                      Text(
                        '9:41',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 60),
                    ],
                  ),
                ),

                // --- Render Area ---
                Expanded(
                  child: currentScreenModel != null
                      ? ActionServiceProvider(
                          actionService: previewActionService,
                          // TODO: Add selection overlay / interaction wrapper here?
                          child: DevityScreenRenderer(
                            screenModel: currentScreenModel,
                            onElementTap: (elementId) {
                              context.read<AppEditorPageEditorBloc>().add(
                                    PreviewElementTapped(elementId: elementId),
                                  );
                            },
                            selectedElementId:
                                editorState is AppEditorPageEditorLoaded
                                    ? editorState.selectedElementId
                                    : null,
                          ),
                        )
                      : Center(
                          child: Text(
                            specState is SpecEditorLoadedState
                                ? (specState.selectedPageId == null
                                    ? 'Select a page to preview'
                                    : 'Error loading screen data for ${specState.selectedPageId}')
                                : 'Loading spec...',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                // --- End Render Area ---

                // Home Indicator
                Container(
                  height: 34,
                  color: Colors.black,
                  child: Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
