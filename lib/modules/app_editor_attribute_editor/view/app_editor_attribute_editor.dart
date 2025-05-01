import 'package:devity_console/modules/app_editor/bloc/app_editor_bloc.dart';
import 'package:devity_console/modules/app_editor_attribute_editor/bloc/app_editor_attribute_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorAttributeEditor] is a widget that provides the attribute editor bloc.
class AppEditorAttributeEditor extends StatelessWidget {
  /// Creates a new instance of [AppEditorAttributeEditor].
  const AppEditorAttributeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorAttributeEditorBloc(),
      child: const AppEditorAttributeEditorView(),
    );
  }
}

/// [AppEditorAttributeEditorView] is a widget that displays and allows editing
/// of attributes for the currently selected item (page, layout, or widget).
class AppEditorAttributeEditorView extends StatelessWidget {
  /// Creates a new instance of [AppEditorAttributeEditorView].
  const AppEditorAttributeEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppEditorBloc, AppEditorState>(
      listener: (context, state) {
        if (state is AppEditorLoadedState) {
          context.read<AppEditorAttributeEditorBloc>().add(
                AppEditorAttributeEditorSelectionChanged(
                  selectedSectionType: state.selectedSectionType,
                  selectedLayoutIndex: state.selectedLayoutIndex,
                  selectedWidgetIndex: state.selectedWidgetIndex,
                  sectionAttributes: state.sectionAttributes,
                  layoutAttributes: state.layoutAttributes,
                  widgetAttributes: state.widgetAttributes,
                ),
              );
        }
      },
      child: BlocBuilder<AppEditorAttributeEditorBloc,
          AppEditorAttributeEditorState>(
        builder: (context, state) {
          if (state is AppEditorAttributeEditorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppEditorAttributeEditorError) {
            return Center(child: Text(state.message));
          }

          if (state is AppEditorAttributeEditorLoaded) {
            return Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(state),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildAttributeEditor(context, state),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Select an item to edit its properties'),
          );
        },
      ),
    );
  }

  String _getTitle(AppEditorAttributeEditorLoaded state) {
    if (state.selectedWidgetIndex != null) {
      return 'Widget Properties';
    } else if (state.selectedLayoutIndex != null) {
      return 'Layout Properties';
    } else if (state.selectedSectionType != null) {
      return 'Page Properties';
    }
    return 'Select an item to edit';
  }

  Widget _buildAttributeEditor(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    if (state.selectedWidgetIndex != null) {
      return _buildWidgetAttributes(context, state);
    } else if (state.selectedLayoutIndex != null) {
      return _buildLayoutAttributes(context, state);
    } else if (state.selectedSectionType != null) {
      return _buildPageAttributes(context, state);
    }
    return const Center(
      child: Text('Select an item to edit its properties'),
    );
  }

  Widget _buildWidgetAttributes(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    return ListView(
      children: state.widgetAttributes.entries.map((entry) {
        return _buildAttributeField(
          context,
          entry.key,
          entry.value.toString(),
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorWidgetAttributeUpdated(
                    attributes: {entry.key: value},
                  ),
                );
          },
        );
      }).toList(),
    );
  }

  Widget _buildLayoutAttributes(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    return ListView(
      children: state.layoutAttributes.entries.map((entry) {
        return _buildAttributeField(
          context,
          entry.key,
          entry.value.toString(),
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorLayoutAttributeUpdated(
                    attributes: {entry.key: value},
                  ),
                );
          },
        );
      }).toList(),
    );
  }

  Widget _buildPageAttributes(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    return ListView(
      children: state.sectionAttributes.entries.map((entry) {
        return _buildAttributeField(
          context,
          entry.key,
          entry.value.toString(),
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorSectionAttributeUpdated(
                    attributes: {entry.key: value},
                  ),
                );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAttributeField(
    BuildContext context,
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            controller: TextEditingController(text: value),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
