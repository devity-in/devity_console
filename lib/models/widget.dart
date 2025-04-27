import 'package:flutter/material.dart';

/// Represents a widget that can be used in the app editor
class AppWidget {
  /// Creates a new [AppWidget]
  const AppWidget({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.description,
    this.properties = const {},
  });

  /// Creates a [AppWidget] from JSON
  factory AppWidget.fromJson(Map<String, dynamic> json) {
    return AppWidget(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      description: json['description'] as String,
      properties: json['properties'] as Map<String, dynamic>,
    );
  }

  /// Unique identifier for the widget
  final String id;

  /// Display name of the widget
  final String name;

  /// Type of the widget (e.g., 'text', 'button', 'container')
  final String type;

  /// Icon to display in the widget library
  final IconData icon;

  /// Description of the widget
  final String description;

  /// Default properties for the widget
  final Map<String, dynamic> properties;

  /// Converts the widget to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon.codePoint,
      'description': description,
      'properties': properties,
    };
  }
}
