import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_attribute_editor/bloc/app_editor_attribute_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:devity_sdk/devity_sdk.dart';
import 'package:devity_sdk/models/spec_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// [SpecEditorAttributeEditor] is a widget that provides the attribute editor bloc.
class SpecEditorAttributeEditor extends StatelessWidget {
  /// Creates a new instance of [SpecEditorAttributeEditor].
  const SpecEditorAttributeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorAttributeEditorBloc(),
      child: const SpecEditorAttributeEditorView(),
    );
  }
}

/// [SpecEditorAttributeEditorView] is a widget that displays and allows editing
/// of attributes for the currently selected item (page, layout, or widget).
class SpecEditorAttributeEditorView extends StatelessWidget {
  /// Creates a new instance of [SpecEditorAttributeEditorView].
  const SpecEditorAttributeEditorView({super.key});

  ComponentModel? _findComponentById(DevitySpec spec, String elementId) {
    print(
      '_findComponentById: Searching for $elementId in spec ${spec.specId}',
    );

    // Recursive search function
    ComponentModel? search(ComponentModel? component) {
      if (component == null) return null;
      if (component.id == elementId) return component;

      if (component is RendererModel) {
        for (final child in component.children) {
          final found = search(child);
          if (found != null) return found;
        }
      }
      return null;
    }

    for (final screen in spec.screens.values) {
      var T = search(screen.appBar);
      if (T != null) return T;
      T = search(screen.body);
      if (T != null) return T;
      T = search(screen.bottomNavBar);
      if (T != null) return T;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppEditorPageEditorBloc, AppEditorPageEditorState>(
      listener: (context, pageEditorState) {
        if (pageEditorState is AppEditorPageEditorLoaded) {
          final selectedElementId = pageEditorState.selectedElementId;
          if (selectedElementId != null) {
            final specEditorState = context.read<SpecEditorBloc>().state;
            if (specEditorState is SpecEditorLoadedState) {
              try {
                final parsedSpec =
                    DevitySpec.fromJson(specEditorState.specData);
                final selectedComponent =
                    _findComponentById(parsedSpec, selectedElementId);
                final globalActions = specEditorState.specData['actions']
                        as Map<String, dynamic>? ??
                    const <String, dynamic>{};

                if (selectedComponent != null) {
                  print(
                    'Selected Component Found: ${selectedComponent.id}, Type: ${selectedComponent.type}',
                  );
                  final attributes = selectedComponent.toJson();
                  context.read<AppEditorAttributeEditorBloc>().add(
                        SelectedElementAttributesUpdated(
                          attributes: attributes,
                          globalActions: globalActions,
                        ),
                      );
                } else {
                  print('Component with ID $selectedElementId not found.');
                  context.read<AppEditorAttributeEditorBloc>().add(
                        SelectedElementAttributesUpdated(
                          globalActions: globalActions,
                        ),
                      );
                }
              } catch (e) {
                print('Error processing spec for attribute editor: $e');
                final globalActions = specEditorState.specData['actions']
                        as Map<String, dynamic>? ??
                    const <String, dynamic>{};
                context.read<AppEditorAttributeEditorBloc>().add(
                      SelectedElementAttributesUpdated(
                        globalActions: globalActions,
                      ),
                    );
              }
            }
          } else {
            // No element selected, clear attributes
            print('No element selected in Page Editor.');
            final specEditorState = context.read<SpecEditorBloc>().state;
            var globalActions = const <String, dynamic>{};
            if (specEditorState is SpecEditorLoadedState) {
              globalActions = specEditorState.specData['actions']
                      as Map<String, dynamic>? ??
                  const <String, dynamic>{};
            }
            context.read<AppEditorAttributeEditorBloc>().add(
                  SelectedElementAttributesUpdated(
                    globalActions: globalActions,
                  ),
                );
          }
        }
      },
      child: BlocListener<SpecEditorBloc, SpecEditorState>(
        listener: (context, state) {
          if (state is SpecEditorLoadedState) {
            final editorBloc = context.read<AppEditorAttributeEditorBloc>();
            if (editorBloc.state is AppEditorAttributeEditorLoaded &&
                (editorBloc.state as AppEditorAttributeEditorLoaded)
                        .selectedElementAttributes ==
                    null) {
              final globalActions =
                  state.specData['actions'] as Map<String, dynamic>? ??
                      const <String, dynamic>{};
              editorBloc.add(
                AppEditorAttributeEditorSelectionChanged(
                  selectedSectionType: state.selectedSectionType,
                  selectedLayoutIndex: state.selectedLayoutIndex,
                  selectedWidgetIndex: state.selectedWidgetIndex,
                  sectionAttributes: state.sectionAttributes,
                  layoutAttributes: state.layoutAttributes,
                  widgetAttributes: state.widgetAttributes,
                  globalActions: globalActions,
                ),
              );
            }
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
      ),
    );
  }

  String _getTitle(AppEditorAttributeEditorLoaded state) {
    if (state.selectedElementAttributes != null &&
        state.selectedElementAttributes!.isNotEmpty) {
      final type = state.selectedElementAttributes!['type'] as String?;
      if (type != null) {
        // Capitalize first letter of type
        final capitalizedType =
            type[0].toUpperCase() + type.substring(1).toLowerCase();
        return '$capitalizedType Properties';
      }
      return 'Element Properties';
    }
    // Fallback to old logic if needed, or just a generic message
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
    if (state.selectedElementAttributes != null &&
        state.selectedElementAttributes!.isNotEmpty) {
      return _buildSelectedElementAttributesList(context, state);
    }
    // Fallback to old logic if selectedElementAttributes is null/empty
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

  Widget _buildSelectedElementAttributesList(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    final attributes = state.selectedElementAttributes!;
    final globalActions = state.globalActions;
    final availableActionIds = globalActions.keys.toList();

    final attributeWidgets = <Widget>[];

    // Define a list of known action ID keys (can be expanded)
    const actionIdKeys = [
      'onClickActionIds',
      'onLoadActionIds',
      'onValueChangeActionIds',
    ];

    attributes.forEach((key, value) {
      // Exclude 'id' and 'type' from being editable in this generic view for now,
      // as they are fundamental. Consider if they should be editable elsewhere or differently.
      if (key == 'id' || key == 'type') {
        attributeWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text('$key: ', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
        return; // Skip making it an editable field
      }

      if (actionIdKeys.contains(key)) {
        var currentSelectedActionIds = <String>[];
        if (value is List) {
          currentSelectedActionIds =
              value.map((item) => item.toString()).toList();
        } else if (value == null) {
          currentSelectedActionIds = [];
        }

        final dropdownItems = availableActionIds
            .map(
              (id) => DropdownItem<String>(
                label: id,
                value: id,
                selected: currentSelectedActionIds.contains(id),
              ),
            )
            .toList();

        final controller = MultiSelectController<String>();

        attributeWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$key (Actions)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                MultiDropdown<String>(
                  items: dropdownItems,
                  controller: controller,
                  onSelectionChange: (List<String> selectedValues) {
                    context.read<AppEditorAttributeEditorBloc>().add(
                          SelectedElementSingleAttributeUpdated(
                            attributeKey: key,
                            newValue: selectedValues,
                            onCommit:
                                (elementId, committedKey, committedValue) {
                              context.read<SpecEditorBloc>().add(
                                    ElementAttributeChangedEvent(
                                      elementId: elementId,
                                      attributeKey: committedKey,
                                      newValue: committedValue,
                                    ),
                                  );
                            },
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        attributeWidgets.add(
          _buildAttributeField(
            context,
            key,
            value, // Pass the original value for type checking
            (newValueString) {
              // This callback receives a string
              dynamic parsedValue = newValueString;
              // Attempt to parse back to original type if possible
              if (value is int) {
                parsedValue = int.tryParse(newValueString) ?? newValueString;
              } else if (value is double) {
                parsedValue = double.tryParse(newValueString) ?? newValueString;
              } else if (value is bool) {
                if (newValueString.toLowerCase() == 'true') {
                  parsedValue = true;
                } else if (newValueString.toLowerCase() == 'false') {
                  parsedValue = false;
                } else {
                  parsedValue =
                      newValueString; // Keep as string if not true/false
                }
              } else if (value is List || value is Map) {
                // TODO: Add proper parsing for Lists/Maps from string if needed, or use a different input widget
                // For now, we send it as a string, which might not be ideal.
                // Consider using json.decode if the string is expected to be valid JSON.
              }

              context.read<AppEditorAttributeEditorBloc>().add(
                    SelectedElementSingleAttributeUpdated(
                      attributeKey: key,
                      newValue: parsedValue,
                      onCommit: (elementId, committedKey, committedValue) {
                        context.read<SpecEditorBloc>().add(
                              ElementAttributeChangedEvent(
                                elementId: elementId,
                                attributeKey: committedKey,
                                newValue: committedValue,
                              ),
                            );
                      },
                    ),
                  );
            },
          ),
        );
      }
    });

    return ListView(children: attributeWidgets);
  }

  Widget _buildWidgetAttributes(
    BuildContext context,
    AppEditorAttributeEditorLoaded state,
  ) {
    final allGlobalActions = state.globalActions;
    final availableActionIds = allGlobalActions.keys.toList();

    final attributeWidgets = <Widget>[];
    state.widgetAttributes.forEach((key, value) {
      if (key == 'onClickActionIds') {
        var currentSelectedActionIds = <String>[];
        if (value is List) {
          currentSelectedActionIds =
              value.map((item) => item.toString()).toList();
        } else if (value == null) {
          currentSelectedActionIds = [];
        }

        final dropdownItems = availableActionIds
            .map(
              (id) => DropdownItem<String>(
                label: id,
                value: id,
                selected: currentSelectedActionIds.contains(id),
              ),
            )
            .toList();

        final controller = MultiSelectController<String>();

        attributeWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'onClickActionIds (MultiSelect)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                MultiDropdown<String>(
                  items: dropdownItems,
                  controller: controller,
                  onSelectionChange: (List<String> selectedValues) {
                    context.read<AppEditorAttributeEditorBloc>().add(
                          AppEditorAttributeEditorWidgetAttributeUpdated(
                            attributes: {
                              'onClickActionIds': selectedValues,
                            },
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        attributeWidgets.add(
          _buildAttributeField(
            context,
            key,
            value.toString(),
            (newValue) {
              dynamic parsedValue = newValue;
              if (value is int) {
                parsedValue = int.tryParse(newValue) ?? newValue;
              } else if (value is double) {
                parsedValue = double.tryParse(newValue) ?? newValue;
              } else if (value is bool) {
                if (newValue.toLowerCase() == 'true') {
                  parsedValue = true;
                } else if (newValue.toLowerCase() == 'false') {
                  parsedValue = false;
                }
              } else if (value is List || value is Map) {
                // For lists/maps, parsing from string needs care
              }

              context.read<AppEditorAttributeEditorBloc>().add(
                    AppEditorAttributeEditorWidgetAttributeUpdated(
                      attributes: {key: parsedValue},
                    ),
                  );
            },
          ),
        );
      }
    });

    return ListView(children: attributeWidgets);
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
    final allGlobalActions = state.globalActions;
    final availableActionIds = allGlobalActions.keys.toList();

    final attributeWidgets = <Widget>[];
    state.sectionAttributes.forEach((key, value) {
      if (key == 'onLoadActionIds') {
        var currentSelectedActionIds = <String>[];
        if (value is List) {
          currentSelectedActionIds =
              value.map((item) => item.toString()).toList();
        } else if (value == null) {
          currentSelectedActionIds = [];
        }

        final dropdownItems = availableActionIds
            .map(
              (id) => DropdownItem<String>(
                label: id,
                value: id,
                selected: currentSelectedActionIds.contains(id),
              ),
            )
            .toList();

        final controller = MultiSelectController<String>();

        attributeWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'onLoadActionIds (MultiSelect)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                MultiDropdown<String>(
                  items: dropdownItems,
                  controller: controller,
                  onSelectionChange: (List<String> selectedValues) {
                    context.read<AppEditorAttributeEditorBloc>().add(
                          AppEditorAttributeEditorSectionAttributeUpdated(
                            attributes: {
                              'onLoadActionIds': selectedValues,
                            },
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        attributeWidgets.add(
          _buildAttributeField(
            context,
            key,
            value.toString(),
            (newValue) {
              dynamic parsedValue = newValue;
              // Basic type parsing, can be expanded
              if (value is int) {
                parsedValue = int.tryParse(newValue) ?? newValue;
              } else if (value is double) {
                parsedValue = double.tryParse(newValue) ?? newValue;
              } else if (value is bool) {
                if (newValue.toLowerCase() == 'true') parsedValue = true;
                if (newValue.toLowerCase() == 'false') parsedValue = false;
              }
              context.read<AppEditorAttributeEditorBloc>().add(
                    AppEditorAttributeEditorSectionAttributeUpdated(
                      attributes: {key: parsedValue},
                    ),
                  );
            },
          ),
        );
      }
    });

    return ListView(children: attributeWidgets);
  }

  Widget _buildAttributeField(
    BuildContext context,
    String label,
    dynamic currentValue, // Changed to dynamic to help with type inference
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
            controller: TextEditingController(
              text: currentValue.toString(),
            ), // Use currentValue
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
