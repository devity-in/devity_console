import 'package:devity_console/modules/app_editor/bloc/app_editor_bloc.dart';
import 'package:devity_console/modules/app_editor_attribute_editor/bloc/app_editor_attribute_editor_bloc.dart';
import 'package:devity_console/modules/app_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorAttributeEditor] is a widget that displays and allows editing
/// of attributes for the currently selected item (page, layout, or widget).
class AppEditorAttributeEditor extends StatelessWidget {
  /// Creates a new instance of [AppEditorAttributeEditor].
  const AppEditorAttributeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppEditorBloc, AppEditorState>(
      builder: (context, state) {
        if (state is! AppEditorLoadedState || state.selectedPageId == null) {
          return const Center(
            child: Text('Select a page to edit its properties'),
          );
        }

        return BlocBuilder<AppEditorPageEditorBloc, AppEditorPageEditorState>(
          builder: (context, pageState) {
            if (pageState is! AppEditorPageEditorLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(pageState),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildAttributeEditor(context, pageState),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getTitle(AppEditorPageEditorLoaded state) {
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
    AppEditorPageEditorLoaded state,
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
    AppEditorPageEditorLoaded state,
  ) {
    final section = state.sections.firstWhere(
      (s) => s.type == state.selectedSectionType,
    );
    final layout = section.layouts[state.selectedLayoutIndex!];
    final widget =
        layout.widgets[state.selectedWidgetIndex!] as Map<String, dynamic>;

    return ListView(
      children: [
        _buildAttributeField(
          context,
          'Name',
          widget['name'] as String,
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorWidgetAttributeUpdated(
                    sectionType: state.selectedSectionType!.name,
                    layoutIndex: state.selectedLayoutIndex!,
                    widgetIndex: state.selectedWidgetIndex!,
                    attributes: {'name': value},
                  ),
                );
          },
        ),
        _buildAttributeField(
          context,
          'Icon',
          widget['icon'].toString(),
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorWidgetAttributeUpdated(
                    sectionType: state.selectedSectionType!.name,
                    layoutIndex: state.selectedLayoutIndex!,
                    widgetIndex: state.selectedWidgetIndex!,
                    attributes: {'icon': value},
                  ),
                );
          },
        ),
        // Add more widget-specific attributes here
      ],
    );
  }

  Widget _buildLayoutAttributes(
    BuildContext context,
    AppEditorPageEditorLoaded state,
  ) {
    final section = state.sections.firstWhere(
      (s) => s.type == state.selectedSectionType,
    );
    final layout = section.layouts[state.selectedLayoutIndex!];

    return ListView(
      children: [
        _buildAttributeField(
          context,
          'Layout Type',
          layout.type.toString().split('.').last,
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorLayoutAttributeUpdated(
                    sectionType: state.selectedSectionType!.name,
                    layoutIndex: state.selectedLayoutIndex!,
                    attributes: {'type': layout.type},
                  ),
                );
          },
        ),
        // Add more layout-specific attributes here
      ],
    );
  }

  Widget _buildPageAttributes(
    BuildContext context,
    AppEditorPageEditorLoaded state,
  ) {
    final section = state.sections.firstWhere(
      (s) => s.type == state.selectedSectionType,
    );

    return ListView(
      children: [
        _buildAttributeField(
          context,
          'Section Type',
          section.type.toString().split('.').last,
          (value) {
            context.read<AppEditorAttributeEditorBloc>().add(
                  AppEditorAttributeEditorSectionAttributeUpdated(
                    sectionType: state.selectedSectionType!.name,
                    attributes: {'type': section.type},
                  ),
                );
          },
        ),
        // Add more page-specific attributes here
      ],
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
