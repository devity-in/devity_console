import 'package:devity_console/modules/app_editor_page_editor/bloc/app_editor_page_editor_bloc.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/page_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorPageEditor] is a StatelessWidget that displays
/// the app editor page editor.
/// It will serve as preview for the page and will have
/// Drag and Drop view builder in future.
class AppEditorPageEditor extends StatelessWidget {
  /// Creates a new instance of [AppEditorPageEditor].
  /// A page will have structure like this:
  ///
  /// Top Navigation Bar
  /// Top Sticky Section [ This section will keep widgets in vertical order ]
  /// Scollable Section
  /// Bottom Sticky Section
  /// Bottom Navigation Bar
  ///
  const AppEditorPageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppEditorPageEditorBloc()
        ..add(const AppEditorPageEditorInitialized()),
      child: BlocBuilder<AppEditorPageEditorBloc, AppEditorPageEditorState>(
        builder: (context, state) {
          if (state is! AppEditorPageEditorLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: Column(
              children: [
                // Top Navigation Bar
                _buildSection(
                  context,
                  state.sections,
                  PageSectionType.topNavigationBar,
                ),
                // Top Sticky Section
                _buildSection(
                  context,
                  state.sections,
                  PageSectionType.topSticky,
                ),
                // Scrollable Section
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildSection(
                      context,
                      state.sections,
                      PageSectionType.scrollable,
                    ),
                  ),
                ),
                // Bottom Sticky Section
                _buildSection(
                  context,
                  state.sections,
                  PageSectionType.bottomSticky,
                ),
                // Bottom Navigation Bar
                _buildSection(
                  context,
                  state.sections,
                  PageSectionType.bottomNavigationBar,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    List<PageSection> sections,
    PageSectionType type,
  ) {
    final section = sections.firstWhere(
      (s) => s.type == type,
      orElse: () => PageSection(type: type),
    );

    final currentState = context.read<AppEditorPageEditorBloc>().state;
    final isSelected = currentState is AppEditorPageEditorLoaded &&
        currentState.selectedSectionType == type &&
        currentState.selectedLayoutIndex == null;

    return GestureDetector(
      onTap: () {
        context.read<AppEditorPageEditorBloc>().add(
              AppEditorPageSectionSelected(sectionType: type),
            );
      },
      child: DragTarget<Object>(
        onWillAcceptWithDetails: (data) => true,
        onAcceptWithDetails: (DragTargetDetails<Object> details) {
          final data = details.data;
          if (data is Map<String, dynamic>) {
            context.read<AppEditorPageEditorBloc>().add(
                  AppEditorPageWidgetDropped(
                    sectionType: type,
                    widgetData: data,
                  ),
                );
          } else if (data is LayoutType) {
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
            decoration: BoxDecoration(
              color: _getSectionColor(type),
              border: Border.all(
                color: isSelected
                    ? Colors.yellow
                    : candidateData.isNotEmpty
                        ? Colors.white
                        : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    type.toString().split('.').last,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ...section.layouts.asMap().entries.map(
                      (entry) => _buildLayout(
                        context,
                        type,
                        entry.key,
                        entry.value,
                      ),
                    ),
                if (section.layouts.isEmpty)
                  ...section.widgets.map(
                    (widget) => _buildWidget(widget as Map<String, dynamic>),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidget(Map<String, dynamic> widget) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(widget['icon'] as IconData),
          const SizedBox(width: 8),
          Text(widget['name'] as String),
        ],
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    PageSectionType sectionType,
    int layoutIndex,
    Layout layout,
  ) {
    final currentState = context.read<AppEditorPageEditorBloc>().state;
    final isSelected = currentState is AppEditorPageEditorLoaded &&
        currentState.selectedSectionType == sectionType &&
        currentState.selectedLayoutIndex == layoutIndex &&
        currentState.selectedWidgetIndex == null;

    return GestureDetector(
      onTap: () {
        context.read<AppEditorPageEditorBloc>().add(
              AppEditorPageLayoutSelected(
                sectionType: sectionType,
                layoutIndex: layoutIndex,
              ),
            );
      },
      child: Container(
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
              layout.type.toString().split('.').last,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildLayoutContent(context, sectionType, layoutIndex, layout),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutContent(
    BuildContext context,
    PageSectionType sectionType,
    int layoutIndex,
    Layout layout,
  ) {
    switch (layout.type) {
      case LayoutType.zStack:
        return Stack(
          children: layout.widgets
              .asMap()
              .entries
              .map(
                (entry) => _buildDraggableWidget(
                  context,
                  sectionType,
                  layoutIndex,
                  entry.key,
                  entry.value as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      case LayoutType.carousel:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: layout.widgets
                .asMap()
                .entries
                .map(
                  (entry) => _buildDraggableWidget(
                    context,
                    sectionType,
                    layoutIndex,
                    entry.key,
                    entry.value as Map<String, dynamic>,
                  ),
                )
                .toList(),
          ),
        );
      case LayoutType.grid:
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: layout.widgets
              .asMap()
              .entries
              .map(
                (entry) => _buildDraggableWidget(
                  context,
                  sectionType,
                  layoutIndex,
                  entry.key,
                  entry.value as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      case LayoutType.vertical:
        return Column(
          children: layout.widgets
              .asMap()
              .entries
              .map(
                (entry) => _buildDraggableWidget(
                  context,
                  sectionType,
                  layoutIndex,
                  entry.key,
                  entry.value as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
    }
  }

  Widget _buildDraggableWidget(
    BuildContext context,
    PageSectionType sectionType,
    int layoutIndex,
    int widgetIndex,
    Map<String, dynamic> widget,
  ) {
    final currentState = context.read<AppEditorPageEditorBloc>().state;
    final isSelected = currentState is AppEditorPageEditorLoaded &&
        currentState.selectedSectionType == sectionType &&
        currentState.selectedLayoutIndex == layoutIndex &&
        currentState.selectedWidgetIndex == widgetIndex;

    return GestureDetector(
      onTap: () {
        context.read<AppEditorPageEditorBloc>().add(
              AppEditorPageWidgetSelected(
                sectionType: sectionType,
                layoutIndex: layoutIndex,
                widgetIndex: widgetIndex,
              ),
            );
      },
      child: LongPressDraggable<int>(
        data: widgetIndex,
        feedback: Material(
          elevation: 4,
          child: _buildWidget(widget),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _buildWidget(widget),
        ),
        child: DragTarget<int>(
          onWillAcceptWithDetails: (data) => data != null,
          onAcceptWithDetails: (DragTargetDetails<int> details) {
            final data = details.data;
            if (data != widgetIndex) {
              context.read<AppEditorPageEditorBloc>().add(
                    AppEditorPageWidgetReordered(
                      sectionType: sectionType,
                      layoutIndex: layoutIndex,
                      oldIndex: data,
                      newIndex: widgetIndex,
                    ),
                  );
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.yellow : Colors.transparent,
                  width: 2,
                ),
              ),
              child: _buildWidget(widget),
            );
          },
        ),
      ),
    );
  }

  Color _getSectionColor(PageSectionType type) {
    switch (type) {
      case PageSectionType.topNavigationBar:
        return Colors.blue;
      case PageSectionType.topSticky:
        return Colors.green;
      case PageSectionType.scrollable:
        return Colors.orange;
      case PageSectionType.bottomSticky:
        return Colors.purple;
      case PageSectionType.bottomNavigationBar:
        return Colors.red;
    }
  }
}
