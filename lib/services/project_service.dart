import 'package:devity_console/models/project.dart';

class ProjectService {
  // TODO: Implement API call to get projects
  Future<List<Project>> getProjects() async {
    final projectsForTest = [
      Project(
        id: '1',
        name: 'Project 1',
        description: 'Project 1 description',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Project(
        id: '2',
        name: 'Project 2',
        description: 'Project 2 description',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    return projectsForTest;
  }

  // TODO: Implement API call to create project
  Future<Project> createProject({
    required String name,
    String? description,
  }) async {
    return Project(
      id: '1',
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
