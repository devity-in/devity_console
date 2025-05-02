import 'package:uuid/uuid.dart';

/// Represents a Project entity fetched from the backend.
class ProjectModel {
  final String id; // Store as String, even though backend uses UUID
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a ProjectModel from a JSON map.
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Basic validation/casting
    final id = json['id'] as String?;
    final name = json['name'] as String?;
    final createdAtStr = json['created_at'] as String?;
    final updatedAtStr = json['updated_at'] as String?;

    if (id == null ||
        name == null ||
        createdAtStr == null ||
        updatedAtStr == null) {
      throw FormatException(
          'Missing required fields in Project JSON: id, name, created_at, updated_at');
    }

    DateTime? createdAt = DateTime.tryParse(createdAtStr);
    DateTime? updatedAt = DateTime.tryParse(updatedAtStr);

    if (createdAt == null || updatedAt == null) {
      throw FormatException('Invalid date format in Project JSON');
    }

    return ProjectModel(
      id: id,
      name: name,
      description: json['description'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a placeholder/empty project model.
  /// Useful for initialization or error states.
  factory ProjectModel.empty() {
    return ProjectModel(
      id: Uuid().v4(), // Generate a temp client-side ID if needed
      name: '',
      description: null,
      createdAt: DateTime(0), // Use epoch or a specific default
      updatedAt: DateTime(0),
    );
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name)';
  }

  // Optional: Add copyWith, toJson if needed later
}
