import 'package:devity_console/services/network_service.dart';
import 'package:dio/dio.dart';

class UnprotectedApiService {
  UnprotectedApiService({
    required NetworkService networkService,
    required String baseUrl,
  })  : _networkService = networkService,
        _baseUrl = baseUrl;
  final NetworkService _networkService;
  final String _baseUrl;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool useCache = false,
    Duration? cacheDuration,
  }) async {
    return _networkService.request(
      '$_baseUrl$path',
      queryParameters: queryParameters,
      useCache: useCache,
      cacheDuration: cacheDuration,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _networkService.request(
      '$_baseUrl$path',
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _networkService.request(
      '$_baseUrl$path',
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _networkService.request(
      '$_baseUrl$path',
      method: 'DELETE',
      queryParameters: queryParameters,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _networkService.request(
      '$_baseUrl$path',
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
    );
  }
}
