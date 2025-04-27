import 'package:devity_console/models/app_page.dart';
import 'package:devity_console/repositories/app_editor_repository.dart';
import 'package:devity_console/services/cache_service.dart';
import 'package:devity_console/services/network_service.dart';

/// Implementation of [AppEditorRepository]
class AppEditorRepositoryImpl implements AppEditorRepository {
  /// Creates a new [AppEditorRepositoryImpl]
  AppEditorRepositoryImpl({
    required this.networkService,
    required this.cacheService,
  });

  final NetworkService networkService;
  final CacheService cacheService;

  @override
  Future<List<AppPage>> loadPages(String projectId) async {
    try {
      // Try to load from cache first
      final cachedPages = await cacheService.getCachedPages(projectId);
      if (cachedPages.isNotEmpty) {
        return cachedPages;
      }

      // If not in cache, load from API
      final response = await networkService.request(
        '/projects/$projectId/pages',
        useCache: true,
      );
      final pages = (response.data['pages'] as List)
          .map((page) => AppPage.fromJson(page as Map<String, dynamic>))
          .toList();

      // Cache the pages
      await cacheService.cachePages(projectId, pages);

      return pages;
    } catch (e) {
      // If API fails, return cached data if available
      final cachedPages = await cacheService.getCachedPages(projectId);
      if (cachedPages.isNotEmpty) {
        return cachedPages;
      }
      rethrow;
    }
  }

  @override
  Future<AppPage> createPage({
    required String projectId,
    required String name,
    required String description,
  }) async {
    final response = await networkService.request(
      '/projects/$projectId/pages',
      method: 'POST',
      data: {
        'name': name,
        'description': description,
      },
    );
    final page = AppPage.fromJson(response.data as Map<String, dynamic>);

    // Update cache
    final pages = await loadPages(projectId);
    await cacheService.cachePages(projectId, [...pages, page]);

    return page;
  }

  @override
  Future<AppPage> updatePage({
    required String projectId,
    required String pageId,
    required String name,
    required String description,
  }) async {
    final response = await networkService.request(
      '/projects/$projectId/pages/$pageId',
      method: 'PUT',
      data: {
        'name': name,
        'description': description,
      },
    );
    final page = AppPage.fromJson(response.data as Map<String, dynamic>);

    // Update cache
    final pages = await loadPages(projectId);
    final updatedPages = pages.map((p) => p.id == pageId ? page : p).toList();
    await cacheService.cachePages(projectId, updatedPages);

    return page;
  }

  @override
  Future<void> deletePage({
    required String projectId,
    required String pageId,
  }) async {
    await networkService.request(
      '/projects/$projectId/pages/$pageId',
      method: 'DELETE',
    );

    // Update cache
    final pages = await loadPages(projectId);
    final updatedPages = pages.where((p) => p.id != pageId).toList();
    await cacheService.cachePages(projectId, updatedPages);
  }

  @override
  Future<void> saveEditorState({
    required String projectId,
    required Map<String, dynamic> state,
  }) async {
    await networkService.request(
      '/projects/$projectId/editor-state',
      method: 'POST',
      data: state,
    );

    // Cache the state
    await cacheService.cacheEditorState(projectId, state);
  }

  @override
  Future<Map<String, dynamic>> loadEditorState(String projectId) async {
    try {
      // Try to load from cache first
      final cachedState = await cacheService.getCachedEditorState(projectId);
      if (cachedState != null) {
        return cachedState;
      }

      // If not in cache, load from API
      final response = await networkService.request(
        '/projects/$projectId/editor-state',
        useCache: true,
      );
      final state = response.data as Map<String, dynamic>;

      // Cache the state
      await cacheService.cacheEditorState(projectId, state);

      return state;
    } catch (e) {
      // If API fails, return cached data if available
      final cachedState = await cacheService.getCachedEditorState(projectId);
      if (cachedState != null) {
        return cachedState;
      }
      rethrow;
    }
  }

  @override
  void clearProjectCache(String projectId) {
    cacheService.clearProjectCache(projectId);
  }

  @override
  void dispose() {
    // No cleanup needed for this implementation
  }
}
