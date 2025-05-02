import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Keep for HttpStatus? Or rely on NetworkService exceptions?

import 'package:devity_console/models/project_model.dart';
import 'package:devity_console/services/network_service.dart'; // Import NetworkService
// import 'package:http/http.dart' as http; // Remove http import

// TODO: Implement proper error handling and logging (Partially handled by NetworkService)
// TODO: Inject HttpClient for testability (NetworkService is injected)

class ProjectService {
  // Inject NetworkService
  final NetworkService _networkService;

  ProjectService({required NetworkService networkService})
      : _networkService = networkService;

  // Remove hardcoded base URL
  // final String _baseUrl =
  //     'http://localhost:8001';

  /// Fetches a list of projects from the backend.
  Future<List<ProjectModel>> getProjects() async {
    const String path = '/projects/'; // Define path
    print('ProjectService: Fetching projects from $path');

    try {
      // Use NetworkService.request with method: 'GET'
      final response = await _networkService.request(path, method: 'GET');

      // NetworkService likely throws exceptions on non-2xx status,
      // so we might not need explicit status code checks here,
      // but rely on its error handling and parsing.
      // Check NetworkService implementation details if specific handling needed.

      // Assuming response.data is already decoded list
      final List<dynamic> responseData = response.data as List<dynamic>;

      final projects = responseData
          .map((jsonItem) =>
              ProjectModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      print('ProjectService: Fetched ${projects.length} projects.');
      return projects;
    } catch (e) {
      // Error handling is largely delegated to NetworkService's interceptors
      // and the ErrorHandlerService it uses.
      // We might re-throw or handle specific application-level errors here.
      print('ProjectService: Exception during getProjects: $e');
      // Re-throw the exception caught by NetworkService/ErrorHandlerService
      // Or throw a more specific ProjectFetchException
      throw Exception('Failed to fetch projects: $e');
    }
  }

  /// Creates a new project via the backend API.
  Future<ProjectModel> createProject(
      {required String name, String? description}) async {
    const String path = '/projects/'; // Define path
    print('ProjectService: Creating project at $path');

    final Map<String, dynamic> body = {
      'name': name,
      if (description != null) 'description': description,
    };

    try {
      // Use NetworkService.request with method: 'POST' and data
      final response = await _networkService.request(
        path,
        method: 'POST',
        data: body,
      );

      // Assuming successful post returns the created object in response.data
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(responseData);

      print('ProjectService: Successfully created project ${project.id}');
      return project;
    } catch (e) {
      print('ProjectService: Exception during createProject: $e');
      // Re-throw or handle specific errors
      throw Exception('Failed to create project: $e');
    }
  }

  // TODO: Add getProjectById, updateProject, deleteProject later if needed
}
