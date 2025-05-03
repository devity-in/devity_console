import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_action_bar/bloc/app_editor_action_bar_bloc.dart';
import 'package:devity_console/modules/spec_editor_action_bar/bloc/app_editor_action_bar_event.dart';
import 'package:devity_console/modules/spec_editor_action_bar/bloc/app_editor_action_bar_state.dart';
import 'package:devity_console/widgets/desktop_basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [SpecEditorActionBar] is a StatelessWidget that displays
/// the app editor action bar.
class SpecEditorActionBar extends StatelessWidget {
  /// Creates a new instance of [SpecEditorActionBar].
  const SpecEditorActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorActionBarBloc()
        ..add(const AppEditorActionBarInitializeEvent()),
      child: const _AppEditorActionBarContent(),
    );
  }
}

class _AppEditorActionBarContent extends StatelessWidget {
  const _AppEditorActionBarContent();

  @override
  Widget build(BuildContext context) {
    final specEditorBloc = context.read<SpecEditorBloc>();

    return BlocBuilder<AppEditorActionBarBloc, AppEditorActionBarState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left side actions
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'App Editor',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
              // Right side actions
              Row(
                children: [
                  DesktopElevatedButton(
                    title: 'Save Changes',
                    onPressed: () {
                      print(
                          'Save Changes button pressed - Dispatching SaveSpecRequested');
                      specEditorBloc.add(const SpecEditorSaveSpecRequested());
                    },
                  ),
                  const SizedBox(width: 12),
                  DesktopOutlinedButton(
                    title: 'Settings',
                    onPressed: () {
                      // TODO: Handle settings action
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
