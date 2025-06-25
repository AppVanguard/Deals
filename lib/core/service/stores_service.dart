import 'dart:convert';
import 'package:deals/core/utils/logger.dart';
import 'package:deals/features/stores/data/models/stores_data.dart';
import 'package:deals/features/stores/data/models/stores_model.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';

class StoresService {
  final HttpClientService _http;

  StoresService({HttpClientService? http}) : _http = http ?? HttpClientService();

  /// Retrieve stores data with optional search, sort, and pagination parameters.
  /// Example endpoint: /stores?search=Amazon&sortField=tittle&page=2&limit=3&sortOrder=asc
  Future<StoresModel> getAllStores({
    String? search,
    String? sortField = "title",
    int? page,
    int? limit,
    String? sortOrder = "asc",
    String? categoryId,
    required String token,
  }) async {
    final queryParameters = <String, String>{
      if (search != null) BackendEndpoints.kSearch: search,
      if (sortField != null) BackendEndpoints.kSortField: sortField,
      if (page != null) BackendEndpoints.kPage: page.toString(),
      if (limit != null) BackendEndpoints.kLimit: limit.toString(),
      if (sortOrder != null) BackendEndpoints.kSortOrder: sortOrder,
      if (categoryId != null) BackendEndpoints.kCategoryId: categoryId,
    };

    final url = Uri.parse(BackendEndpoints.stores)
        .replace(queryParameters: queryParameters);
    try {
      final response =
          await _http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return StoresModel.fromJson(jsonMap);
      } else {
        appLog('Error fetching stores: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch stores: ${response.body}');
      }
    } catch (e) {
      appLog('Exception in getAllStores: ${e.toString()}');
      rethrow;
    }
  }

  /// Retrieve a single store's data by its [id].
  Future<StoresModel> getStoreById(String id, String token) async {
    final url = Uri.parse('${BackendEndpoints.stores}/$id');
    try {
      final response =
          await _http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        // Instead of trying to parse into `StoresModel` directly,
        // parse the single store into `StoresData`,
        // and then build a `StoresModel` whose `data` list contains just this single item.
        final singleStore = StoresData.fromJson(jsonMap);
        return StoresModel(
          data: [singleStore],
        );
      } else {
        appLog('Error fetching store by id: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch store by id: ${response.body}');
      }
    } catch (e) {
      appLog('Exception in getStoreById: ${e.toString()}');
      rethrow;
    }
  }
}
