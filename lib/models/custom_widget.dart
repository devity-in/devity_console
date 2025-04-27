import 'package:devity_console/models/widget.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/layout.dart';
import 'package:flutter/material.dart';

/// Represents a custom widget created by the user
class CustomWidget extends AppWidget {
  /// Creates a new [CustomWidget]
  const CustomWidget({
    required super.id,
    required super.name,
    required super.type,
    required super.icon,
    required super.description,
    required this.isPublic,
    required this.layout,
    required this.components,
    super.properties = const {},
  });

  /// Creates a [CustomWidget] from JSON
  factory CustomWidget.fromJson(Map<String, dynamic> json) {
    return CustomWidget(
      id: json['id'] as String,
      name: json['name'] as String,
      type: 'custom',
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      description: json['description'] as String,
      isPublic: json['isPublic'] as bool,
      layout: LayoutType.values.firstWhere(
        (e) => e.toString() == json['layout'] as String,
      ),
      components: (json['components'] as List)
          .map((c) => AppWidget.fromJson(c as Map<String, dynamic>))
          .toList(),
      properties: json['properties'] as Map<String, dynamic>,
    );
  }

  /// Whether this widget is public or private
  final bool isPublic;

  /// The layout type for this custom widget
  final LayoutType layout;

  /// The list of widgets that make up this custom widget
  final List<AppWidget> components;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'isPublic': isPublic,
      'layout': layout.toString(),
      'components': components.map((c) => c.toJson()).toList(),
    };
  }
}
