class Attribute {
  final String id;
  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attribute({
    required this.id,
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isRequired: json['is_required'] as bool,
      defaultValue: json['default_value'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_required': isRequired,
      'default_value': defaultValue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
