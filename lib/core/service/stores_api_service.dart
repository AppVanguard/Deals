// stores_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:deals/features/stores/data/models/stores_model/stores_model.dart';
import 'package:http/http.dart' as http;
import 'package:deals/core/utils/backend_endpoints.dart';

class StoresService {
  /// Retrieve stores data with optional search and pagination parameters.
  /// Example endpoint: /stores?search=Amazon&page=2&limit=3
  Future<StoresModel> getAllStores(
      {String? search, int? page, int? limit}) async {
    final queryParameters = <String, String>{
      if (search != null) BackendEndpoints.kSearch: search,
      if (page != null) BackendEndpoints.kPage: page.toString(),
      if (limit != null) BackendEndpoints.kLimit: limit.toString(),
    };

    final url = Uri.parse(BackendEndpoints.stores)
        .replace(queryParameters: queryParameters);

    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return StoresModel.fromJson(jsonMap);
      } else {
        log('Error fetching stores: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch stores: ${response.body}');
      }
    } catch (e) {
      log('Exception in getAllStores: ${e.toString()}');
      rethrow;
    }
  }

  /// Retrieve a single store's data by its [id].
  Future<StoresModel> getStoreById(String id) async {
    // Assuming the endpoint for a single store is `${BackendEndpoints.stores}/id`
    final url = Uri.parse('${BackendEndpoints.stores}/$id');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return StoresModel.fromJson(jsonMap);
      } else {
        log('Error fetching store by id: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch store by id: ${response.body}');
      }
    } catch (e) {
      log('Exception in getStoreById: ${e.toString()}');
      rethrow;
    }
  }
}
