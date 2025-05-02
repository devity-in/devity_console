import 'package:devity_console/modules/spec_editor_page_list/models/page.dart'
    as models;
import 'package:flutter/material.dart';

/// Widget for the page list search bar
class PageListSearchBar extends StatelessWidget {
  /// Constructor
  const PageListSearchBar({
    required this.onSearchChanged,
    super.key,
  });

  /// Callback when search text changes
  final void Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search pages...',
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
      ),
    );
  }
}

/// Widget for the page list add button
class PageListAddButton extends StatelessWidget {
  /// Constructor
  const PageListAddButton({
    required this.onPressed,
    super.key,
  });

  /// Callback when button is pressed
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton.filled(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Widget for a single page card
class PageCard extends StatelessWidget {
  /// Constructor
  const PageCard({
    required this.page,
    required this.onDelete,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  /// The page to display
  final models.Page page;

  /// Callback when delete button is pressed
  final void Function() onDelete;

  /// Whether this page is selected
  final bool isSelected;

  /// Callback when page is selected
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outlineVariant.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      page.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    color: colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (page.description != null) ...[
                Text(
                  page.description!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for the page list grid
class PageListGrid extends StatelessWidget {
  /// Constructor
  const PageListGrid({
    required this.pages,
    required this.onDeletePage,
    required this.selectedPageId,
    required this.onPageSelected,
    super.key,
  });

  /// List of pages to display
  final List<models.Page> pages;

  /// Callback when a page is deleted
  final void Function(String) onDeletePage;

  /// The ID of the currently selected page
  final String? selectedPageId;

  /// Callback when a page is selected
  final void Function(String) onPageSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PageCard(
            page: page,
            onDelete: () => onDeletePage(page.id),
            isSelected: selectedPageId == page.id,
            onSelected: () => onPageSelected(page.id),
          ),
        );
      },
    );
  }
}

/// Widget for displaying an empty state when no pages are found
class PageListEmptyState extends StatelessWidget {
  /// Constructor
  const PageListEmptyState({
    required this.onAddPage,
    super.key,
  });

  /// Callback when add page button is pressed
  final VoidCallback onAddPage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Pages Found',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get started by creating your first page',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAddPage,
            icon: const Icon(Icons.add),
            label: const Text('Create Page'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
