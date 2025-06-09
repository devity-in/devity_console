import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_list/bloc/app_editor_page_list_bloc.dart';
import 'package:devity_console/modules/spec_editor_page_list/bloc/app_editor_page_list_event.dart';
import 'package:devity_console/modules/spec_editor_page_list/bloc/app_editor_page_list_state.dart';
import 'package:devity_console/modules/spec_editor_page_list/widgets/add_page.dart';
import 'package:devity_console/modules/spec_editor_page_list/widgets/app_editor_page_list_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorPageList] is a StatelessWidget that displays
/// the app editor page list.
class AppEditorPageList extends StatelessWidget {
  /// Creates a new instance of [AppEditorPageList].
  const AppEditorPageList({
    required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppEditorPageListBloc(projectId: projectId)
            ..add(const AppEditorPageListStartedEvent()),
      child: const AppEditorPageListView(),
    );
  }
}

/// [AppEditorPageListView] is a StatelessWidget that displays
/// the app editor page list view.
class AppEditorPageListView extends StatelessWidget {
  /// Creates a new instance of [AppEditorPageListView].
  const AppEditorPageListView({super.key});

  void _showAddPageDialog(BuildContext mainContext) {
    showDialog<void>(
      context: mainContext,
      builder: (dialogContext) => AddPageDialog(
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
        onSave: (Map<String, String> data) {
          mainContext.read<AppEditorPageListBloc>()
            ..add(
              AppEditorPageListAddPageEvent(
                name: data['name']!,
                description: data['description']!,
              ),
            )
            ..add(
              AppEditorPageListAddPageEvent(
                name: data['name']!,
                description: data['description']!,
              ),
            );
          // Select the newly created page
          mainContext.read<SpecEditorBloc>().add(
                SpecEditorSelectPageEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                ),
              );
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppEditorPageListBloc, AppEditorPageListState>(
      builder: (context, state) {
        if (state is AppEditorPageListLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppEditorPageListErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    context
                        .read<AppEditorPageListBloc>()
                        .add(const AppEditorPageListStartedEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is AppEditorPageListLoadedState) {
          if (state.pages.isEmpty) {
            return PageListEmptyState(
              onAddPage: () => _showAddPageDialog(context),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PageListSearchBar(
                        onSearchChanged: (query) {
                          context
                              .read<AppEditorPageListBloc>()
                              .add(AppEditorPageListSearchEvent(query: query));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    PageListAddButton(
                      onPressed: () => _showAddPageDialog(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<SpecEditorBloc, SpecEditorState>(
                  builder: (context, appEditorState) {
                    final selectedPageId =
                        appEditorState is SpecEditorLoadedState
                            ? appEditorState.selectedPageId
                            : null;

                    return PageListGrid(
                      pages: state.pages,
                      selectedPageId: selectedPageId,
                      onPageSelected: (pageId) {
                        context.read<SpecEditorBloc>().add(
                              SpecEditorSelectPageEvent(
                                id: pageId,
                              ),
                            );
                      },
                      onDeletePage: (pageId) {
                        context.read<AppEditorPageListBloc>().add(
                              AppEditorPageListDeletePageEvent(
                                pageId: pageId,
                              ),
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
