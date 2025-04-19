import 'package:devity_console/models/project.dart';

class ProjectService {
  Future<List<Project>> getProjects() async {
    // TODO: Implement API call to get projects
    return [];
  }

  Future<Project> createProject({
    required String name,
    String? description,
  }) async {
    // TODO: Implement API call to create project
    return Project(
      id: '1',
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
