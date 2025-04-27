import 'package:devity_console/models/custom_widget.dart';

/// Repository for managing custom widgets
abstract class CustomWidgetRepository {
  /// Loads all custom widgets for a project
  Future<List<CustomWidget>> loadCustomWidgets(String projectId);

  /// Loads public custom widgets
  Future<List<CustomWidget>> loadPublicWidgets();

  /// Saves a custom widget
  Future<void> saveCustomWidget(String projectId, CustomWidget widget);

  /// Deletes a custom widget
  Future<void> deleteCustomWidget(String projectId, String widgetId);

  /// Updates a custom widget
  Future<void> updateCustomWidget(String projectId, CustomWidget widget);
}
