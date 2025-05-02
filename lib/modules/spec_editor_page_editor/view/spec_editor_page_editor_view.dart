import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
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
    return BlocListener<AppEditorPageEditorBloc, AppEditorPageEditorState>(
      listener: (context, state) {
        if (state is AppEditorPageEditorLoaded) {
          if (state.selectedWidgetIndex != null) {
            context.read<SpecEditorBloc>().add(
                  SpecEditorSelectWidgetEvent(
                    sectionType: state.selectedSectionType!,
                    layoutIndex: state.selectedLayoutIndex!,
                    widgetIndex: state.selectedWidgetIndex!,
                  ),
                );
          } else if (state.selectedLayoutIndex != null) {
            context.read<SpecEditorBloc>().add(
                  SpecEditorSelectLayoutEvent(
                    sectionType: state.selectedSectionType!,
                    layoutIndex: state.selectedLayoutIndex!,
                  ),
                );
          } else if (state.selectedSectionType != null) {
            context.read<SpecEditorBloc>().add(
                  SpecEditorSelectSectionEvent(
                    sectionType: state.selectedSectionType!,
                  ),
                );
          } else {
            context.read<SpecEditorBloc>().add(
                  const SpecEditorClearSelectionEvent(),
                );
          }
        }
      },
      child: BlocBuilder<AppEditorPageEditorBloc, AppEditorPageEditorState>(
        builder: (context, state) {
          if (state is! AppEditorPageEditorLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Container(
              width: 375, // iPhone width
              height: 812, // iPhone height
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.grey[800]!,
                  width: 2,
                ),
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
                  backgroundColor: Colors.white,
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
                      // Top Navigation Bar
                      _buildSection(
                        context,
                        PageSectionType.topNavigationBar,
                        state.selectedSectionType,
                        state.selectedLayoutIndex,
                      ),
                      // Top Sticky Section
                      _buildSection(
                        context,
                        PageSectionType.topSticky,
                        state.selectedSectionType,
                        state.selectedLayoutIndex,
                      ),
                      // Scrollable Section
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildSection(
                            context,
                            PageSectionType.scrollable,
                            state.selectedSectionType,
                            state.selectedLayoutIndex,
                          ),
                        ),
                      ),
                      // Bottom Sticky Section
                      _buildSection(
                        context,
                        PageSectionType.bottomSticky,
                        state.selectedSectionType,
                        state.selectedLayoutIndex,
                      ),
                      // Bottom Navigation Bar
                      _buildSection(
                        context,
                        PageSectionType.bottomNavigationBar,
                        state.selectedSectionType,
                        state.selectedLayoutIndex,
                      ),
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
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    PageSectionType type,
    PageSectionType? selectedSectionType,
    int? selectedLayoutIndex,
  ) {
    final isSelected =
        selectedSectionType == type && selectedLayoutIndex == null;

    return GestureDetector(
      onTap: () {
        context.read<AppEditorPageEditorBloc>().add(
              AppEditorPageEditorSelectSection(sectionType: type),
            );
      },
      child: DragTarget<Object>(
        onWillAcceptWithDetails: (data) => true,
        onAcceptWithDetails: (DragTargetDetails<Object> details) {
          final data = details.data;
          if (data is Map<String, dynamic>) {
            // Handle widget drop
            context.read<AppEditorPageEditorBloc>().add(
                  AppEditorPageWidgetDropped(
                    sectionType: type,
                    widgetData: data,
                  ),
                );
          } else if (data is LayoutType) {
            // Handle layout drop
            context.read<AppEditorPageEditorBloc>().add(
                  AppEditorPageLayoutDropped(
                    sectionType: type,
                    layoutType: data,
                  ),
                );
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.white,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.toString().split('.').last,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildLayouts(context, type),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLayouts(BuildContext context, PageSectionType sectionType) {
    return BlocBuilder<AppEditorPageEditorBloc, AppEditorPageEditorState>(
      builder: (context, state) {
        if (state is! AppEditorPageEditorLoaded) return const SizedBox();

        final section = state.sections.firstWhere(
          (s) => s.type == sectionType,
          orElse: () => PageSection(type: sectionType),
        );

        return Column(
          children: section.layouts.asMap().entries.map((entry) {
            final index = entry.key;
            final layout = entry.value;
            final isSelected = state.selectedLayoutIndex == index;

            return GestureDetector(
              onTap: () {
                context.read<AppEditorPageEditorBloc>().add(
                      AppEditorPageEditorSelectLayout(
                        sectionType: sectionType,
                        layoutIndex: index,
                      ),
                    );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layout.type.toString().split('.').last,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildWidgets(context, sectionType, index, layout),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildWidgets(
    BuildContext context,
    PageSectionType sectionType,
    int layoutIndex,
    Layout layout,
  ) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        context.read<AppEditorPageEditorBloc>().add(
              AppEditorPageWidgetReordered(
                sectionType: sectionType,
                layoutIndex: layoutIndex,
                oldIndex: oldIndex,
                newIndex: newIndex,
              ),
            );
      },
      children: layout.widgets.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final state = context.read<AppEditorPageEditorBloc>().state;
        final isSelected = state is AppEditorPageEditorLoaded &&
            state.selectedWidgetIndex == index;

        return GestureDetector(
          key: ValueKey('widget_$index'),
          onTap: () {
            context.read<AppEditorPageEditorBloc>().add(
                  AppEditorPageEditorSelectWidget(
                    sectionType: sectionType,
                    layoutIndex: layoutIndex,
                    widgetIndex: index,
                  ),
                );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
            child: Text(
              widget.toString(),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        );
      }).toList(),
    );
  }
}
