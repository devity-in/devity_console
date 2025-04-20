import 'package:devity_console/config/constants.dart';
import 'package:devity_console/widgets/desktop_basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_editor_action_bar_bloc.dart';
import '../bloc/app_editor_action_bar_event.dart';
import '../bloc/app_editor_action_bar_state.dart';

/// [AppEditorActionBar] is a StatelessWidget that displays
/// the app editor action bar.
class AppEditorActionBar extends StatelessWidget {
  /// Creates a new instance of [AppEditorActionBar].s
  const AppEditorActionBar({super.key});

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
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        // TODO: Handle back navigation
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'App Editor',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
