/// Represents summary information for a Spec, used for listings.
class SpecSummaryModel {
  final String id; // UUID as String
  final String projectId; // UUID as String
  // TODO: Add a user-friendly display name/version later, maybe derived from content?
  final DateTime createdAt;
  final DateTime updatedAt;

  SpecSummaryModel({
    required this.id,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a SpecSummaryModel from a JSON map.
  /// Assumes backend returns these specific fields.
  factory SpecSummaryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final projectId = json['project_id'] as String?;
    final createdAtStr = json['created_at'] as String?;
    final updatedAtStr = json['updated_at'] as String?;

    if (id == null ||
        projectId == null ||
        createdAtStr == null ||
        updatedAtStr == null) {
      throw FormatException(
          'Missing required fields in SpecSummary JSON: id, project_id, created_at, updated_at');
    }

    DateTime? createdAt = DateTime.tryParse(createdAtStr);
    DateTime? updatedAt = DateTime.tryParse(updatedAtStr);

    if (createdAt == null || updatedAt == null) {
      throw FormatException('Invalid date format in SpecSummary JSON');
    }

    return SpecSummaryModel(
      id: id,
      projectId: projectId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'SpecSummaryModel(id: $id, projectId: $projectId)';
  }
}
