import 'package:devity_console/modules/app_editor_action_bar/bloc/app_editor_action_bar_bloc.dart';
import 'package:devity_console/modules/app_editor_action_bar/bloc/app_editor_action_bar_event.dart';
import 'package:devity_console/modules/app_editor_action_bar/bloc/app_editor_action_bar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorActionBar] is a StatelessWidget that displays
/// the app editor action bar.
class AppEditorActionBar extends StatelessWidget {
  /// Creates a new instance of [AppEditorActionBar].
  const AppEditorActionBar({super.key});

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
    return BlocBuilder<AppEditorActionBarBloc, AppEditorActionBarState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              // Left side actions
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'App Editor',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // Right side actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      // TODO: Handle save action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
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
