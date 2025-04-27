import 'package:devity_console/models/custom_widget.dart';
import 'package:devity_console/repositories/custom_widget_repository.dart';
import 'package:devity_console/services/cache_service.dart';
import 'package:devity_console/services/network_service.dart';

/// Implementation of [CustomWidgetRepository]
class CustomWidgetRepositoryImpl implements CustomWidgetRepository {
  /// Creates a new [CustomWidgetRepositoryImpl]
  CustomWidgetRepositoryImpl({
    required this.networkService,
    required this.cacheService,
  });

  final NetworkService networkService;
  final CacheService cacheService;

  @override
  Future<List<CustomWidget>> loadCustomWidgets(String projectId) async {
    try {
      // Try to load from cache first
      final cachedWidgets =
          await cacheService.getCachedCustomWidgets(projectId);
      if (cachedWidgets.isNotEmpty) {
        return cachedWidgets;
      }

      // If not in cache, load from API
      final response = await networkService.request(
        '/projects/$projectId/custom-widgets',
        useCache: true,
      );
      final widgets = (response.data['widgets'] as List)
          .map(
            (widget) => CustomWidget.fromJson(widget as Map<String, dynamic>),
          )
          .toList();

      // Cache the widgets
      await cacheService.cacheCustomWidgets(projectId, widgets);

      return widgets;
    } catch (e) {
      // If API fails, return cached data if available
      final cachedWidgets =
          await cacheService.getCachedCustomWidgets(projectId);
      if (cachedWidgets.isNotEmpty) {
        return cachedWidgets;
      }
      rethrow;
    }
  }

  @override
  Future<List<CustomWidget>> loadPublicWidgets() async {
    try {
      final response = await networkService.request(
        '/custom-widgets/public',
        useCache: true,
      );
      return (response.data['widgets'] as List)
          .map(
            (widget) => CustomWidget.fromJson(widget as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveCustomWidget(String projectId, CustomWidget widget) async {
    await networkService.request(
      '/projects/$projectId/custom-widgets',
      method: 'POST',
      data: widget.toJson(),
    );

    // Update cache
    final widgets = await loadCustomWidgets(projectId);
    await cacheService.cacheCustomWidgets(projectId, [...widgets, widget]);
  }

  @override
  Future<void> deleteCustomWidget(String projectId, String widgetId) async {
    await networkService.request(
      '/projects/$projectId/custom-widgets/$widgetId',
      method: 'DELETE',
    );

    // Update cache
    final widgets = await loadCustomWidgets(projectId);
    final updatedWidgets = widgets.where((w) => w.id != widgetId).toList();
    await cacheService.cacheCustomWidgets(projectId, updatedWidgets);
  }

  @override
  Future<void> updateCustomWidget(String projectId, CustomWidget widget) async {
    await networkService.request(
      '/projects/$projectId/custom-widgets/${widget.id}',
      method: 'PUT',
      data: widget.toJson(),
    );

    // Update cache
    final widgets = await loadCustomWidgets(projectId);
    final updatedWidgets =
        widgets.map((w) => w.id == widget.id ? widget : w).toList();
    await cacheService.cacheCustomWidgets(projectId, updatedWidgets);
  }
}
