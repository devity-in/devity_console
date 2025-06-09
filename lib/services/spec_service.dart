import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Keep for HttpStatus? Or rely on NetworkService exceptions?

import 'package:devity_console/models/spec_summary_model.dart';
import 'package:devity_console/services/network_service.dart'; // Import NetworkService
// import 'package:http/http.dart' as http; // Remove http import

// TODO: Implement proper error handling and logging (Partially handled by NetworkService)
// TODO: Inject HttpClient for testability (NetworkService is injected)

class SpecService {
  // Inject NetworkService
  final NetworkService _networkService;

  SpecService({required NetworkService networkService, required errorHandler})
      : _networkService = networkService;

  // Remove hardcoded base URL
  // final String _baseUrl = 'http://localhost:8001';

  /// Fetches a list of spec summaries for a given project.
  Future<List<SpecSummaryModel>> getSpecSummaries(String projectId) async {
    final String path = '/projects/$projectId/specs/'; // Define path
    print('SpecService: Fetching specs for project $projectId from $path');
    try {
      // Use NetworkService.request with method: 'GET'
      final response = await _networkService.request(path, method: 'GET');

      // Assuming response.data is already decoded list
      final List<dynamic> responseData = response.data as List<dynamic>;

      final specs = responseData
          .map((jsonItem) =>
              SpecSummaryModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      print(
          'SpecService: Fetched ${specs.length} specs for project $projectId.');
      return specs;
    } catch (e) {
      print('SpecService: Exception during getSpecSummaries: $e');
      // Rethrow or handle specific errors
      throw Exception('Failed to fetch specs for project $projectId: $e');
    }
  }

  /// Fetches the full content JSON of a specific spec.
  /// Uses the SDK endpoint which returns the raw content.
  Future<Map<String, dynamic>> getSpecContent(String specId) async {
    final String path = '/sdk/specs/$specId'; // Define path
    print('SpecService: Fetching spec content for $specId from $path');

    try {
      // Use NetworkService.request with method: 'GET'
      final response = await _networkService.request(path, method: 'GET');

      // Assuming response.data is already decoded map
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;

      print('SpecService: Fetched content for spec $specId.');
      return responseData;
    } catch (e) {
      // NetworkService/ErrorHandler should convert 404 to specific exception
      print('SpecService: Exception during getSpecContent: $e');
      // Rethrow or handle specific errors
      throw Exception('Failed to fetch spec content for $specId: $e');
    }
  }

  /// Updates the content of a specific spec.
  /// Requires fetching the current spec first to get other fields (name, project_id).
  Future<void> updateSpecContent(
      String specId, Map<String, dynamic> newContent) async {
    final String path = '/specs/$specId/'; // Define path
    print('SpecService: Updating spec content for $specId at $path');

    // --- Refined Logic based on M3 Commit 8 Plan ---
    // 1. Fetch the *full* spec data first (not just content from /sdk/)
    //    We need the name and project_id for the PUT request body.
    //    Let's assume a GET /specs/{specId} endpoint exists for this (Backend needs adjustment?)
    //    OR, if the console only edits content, maybe the backend PUT doesn't require name/project_id?
    //    For now, let's *assume* the backend PUT /specs/{specId} ONLY needs the content.
    //    This aligns with the previous http.put implementation.
    //    If backend validation fails later, we will adjust.
    //
    //    final fullSpecPath = '/specs/$specId/';
    //    final currentSpecResponse = await _networkService.request(fullSpecPath, method: 'GET');
    //    final currentSpecData = currentSpecResponse.data as Map<String, dynamic>;

    // Backend expects the content nested under a "content" key in the PUT body?
    // Let's assume it needs the whole SpecUpdate model based on backend code:
    // { "name": "string", "content": {}, "project_id": "uuid" }
    // This means we DO need to fetch the full spec first.

    // === Let's implement the fetch-then-update logic ===

    try {
      // Step 1: Fetch current full SpecRead data (assuming GET /specs/{specId})
      final String getPath = '/specs/$specId/'; // Assuming this endpoint exists
      print('SpecService: Fetching current spec details from $getPath');
      final currentSpecResponse =
          await _networkService.request(getPath, method: 'GET');
      final currentSpecData = currentSpecResponse.data as Map<String, dynamic>;

      // Validate required fields exist
      final String? currentName = currentSpecData['name'] as String?;
      final String? currentProjectId = currentSpecData['project_id'] as String?;
      if (currentName == null || currentProjectId == null) {
        throw Exception(
            'Failed to get current spec name or project ID for update.');
      }

      // Step 2: Prepare the update payload (SpecUpdate model)
      final Map<String, dynamic> updatePayload = {
        'name': currentName, // Keep existing name
        'project_id': currentProjectId, // Keep existing project_id
        'content': newContent, // Use the new content provided
      };

      // Step 3: Perform the PUT request with the update payload
      await _networkService.request(
        path, // PUT to /specs/{specId}/
        method: 'PUT',
        data: updatePayload, // Send the full payload
      );

      print('SpecService: Successfully updated spec $specId.');
    } catch (e) {
      print('SpecService: Exception during updateSpecContent: $e');
      // Rethrow or handle specific errors
      throw Exception('Failed to update spec $specId: $e');
    }
  }
}
