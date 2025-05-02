import 'dart:convert';

import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_event.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecEditorScreen extends StatelessWidget {
  final String projectId; // Keep projectId for context if needed
  final String specId;

  const SpecEditorScreen({
    super.key,
    required this.projectId,
    required this.specId,
  });

  // TODO: Define proper route name
  static const routeName = '/project/:projectId/spec/:specId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SpecEditorBloc()..add(SpecEditorLoadRequested(specId: specId)),
      child: SpecEditorView(projectId: projectId, specId: specId),
    );
  }
}

class SpecEditorView extends StatefulWidget {
  final String projectId;
  final String specId;

  const SpecEditorView({
    super.key,
    required this.projectId,
    required this.specId,
  });

  @override
  State<SpecEditorView> createState() => _SpecEditorViewState();
}

class _SpecEditorViewState extends State<SpecEditorView> {
  // Controller for the TextField
  late final TextEditingController _textController;
  bool _isContentInitialized = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Show spec name/version?
        title: Text('Edit Spec (ID: ${widget.specId})'),
        actions: [
          // Save Button
          BlocBuilder<SpecEditorBloc, SpecEditorConcreteState>(
            builder: (context, state) {
              // Disable button while loading or saving
              final canSave = state.status == SpecEditorStatus.loaded;
              return IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save Draft',
                onPressed: canSave
                    ? () {
                        context
                            .read<SpecEditorBloc>()
                            .add(SpecEditorSaveRequested());
                      }
                    : null,
              );
            },
          ),
          // TODO: Add Publish button later?
        ],
      ),
      body: BlocConsumer<SpecEditorBloc, SpecEditorConcreteState>(
        // Provide previous state to the listener to detect transitions
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          // Need the previous state to check transition from saving to loaded
          final previousStatus = context
              .read<SpecEditorBloc>()
              .state
              .status; // This might not capture the immediate previous state reliably.
          // Alternative: Add previousStatus to the state itself, or use a dedicated feedback stream.

          // For now, let's use a simpler approach: check current status

          // Update TextField logic (check if necessary with BlocConsumer)
          if ((state.status == SpecEditorStatus.loaded ||
                  state.status == SpecEditorStatus.error) &&
              !_isContentInitialized) {
            if (_textController.text != state.currentContent) {
              _textController.text = state.currentContent;
            }
            _isContentInitialized = true;
          } else if (state.status == SpecEditorStatus.loading) {
            _isContentInitialized = false;
          }

          // Show feedback on save error
          if (state.status == SpecEditorStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
                .removeCurrentSnackBar(); // Remove previous if any
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          // Show feedback on successful save
          // Check if the status just became loaded *after* being saving
          // NOTE: This relies on listenWhen or careful state management.
          // A simpler check for now (might show on initial load too, needs refinement):
          else if (state.status == SpecEditorStatus.loaded &&
              _isContentInitialized) {
            // We check _isContentInitialized to avoid showing on initial load.
            // A better way might be needed if initial load can be very fast.
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Draft saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SpecEditorStatus.loading ||
              state.status == SpecEditorStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          // Use a full-height TextField for the JSON editor
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Spec JSON here...',
                // TODO: Add syntax highlighting later?
              ),
              maxLines: null, // Allows unlimited lines
              expands: true, // Fills available space
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                  fontFamily: 'monospace'), // Use monospace font
              // Send changes to the Bloc
              onChanged: (value) {
                _isContentInitialized =
                    true; // Mark as initialized once user types
                context
                    .read<SpecEditorBloc>()
                    .add(SpecEditorContentChanged(newContent: value));
              },
            ),
          );
        },
      ),
    );
  }
}
