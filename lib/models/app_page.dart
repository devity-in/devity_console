/// Model class representing an app page
class AppPage {
  /// Creates a new [AppPage]
  const AppPage({
    required this.id,
    required this.name,
    required this.description,
    this.content,
    this.metadata = const {},
  });

  /// Creates an [AppPage] from a JSON map
  factory AppPage.fromJson(Map<String, dynamic> json) {
    return AppPage(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      content: json['content'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// The unique identifier of the page
  final String id;

  /// The name of the page
  final String name;

  /// The description of the page
  final String description;

  /// The content of the page (widgets, layouts, etc.)
  final Map<String, dynamic>? content;

  /// Additional metadata for the page
  final Map<String, dynamic> metadata;

  /// Creates a copy of this [AppPage] with the given fields replaced with the new values
  AppPage copyWith({
    String? id,
    String? name,
    String? description,
    Map<String, dynamic>? content,
    Map<String, dynamic>? metadata,
  }) {
    return AppPage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this [AppPage] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'metadata': metadata,
    };
  }
}
