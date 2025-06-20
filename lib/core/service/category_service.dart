import 'dart:convert';
import 'dart:developer';
import 'package:deals/core/models/category_model/category_model.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';

class CategoriesService {
  final HttpClientService _http;

  CategoriesService({HttpClientService? http}) : _http = http ?? HttpClientService();
  /// Retrieve categories data with optional sort and pagination parameters.
  /// Example endpoint: /categories?sortField=tittle&page=1&limit=10&sortOrder=desc
  Future<CategoryModel> getAllCategories({
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    required String token,
  }) async {
    final queryParameters = <String, String>{
      if (sortField != null) BackendEndpoints.kSortField: sortField,
      if (page != null) BackendEndpoints.kPage: page.toString(),
      if (limit != null) BackendEndpoints.kLimit: limit.toString(),
      if (sortOrder != null) BackendEndpoints.kSortOrder: sortOrder,
    };

    final url = Uri.parse(BackendEndpoints.categories)
        .replace(queryParameters: queryParameters);

    try {
      final response =
          await _http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return CategoryModel.fromJson(jsonMap);
      } else {
        log('Error fetching categories: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch categories: ${response.body}');
      }
    } catch (e) {
      log('Exception in getAllCategories: ${e.toString()}');
      rethrow;
    }
  }

  /// Retrieve a single category's data by its [id].
  Future<CategoryModel> getCategoryById(String id, String token) async {
    final url = Uri.parse('${BackendEndpoints.categories}/$id');
    try {
      final response =
          await _http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return CategoryModel.fromJson(jsonMap);
      } else {
        log('Error fetching category by id: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch category by id: ${response.body}');
      }
    } catch (e) {
      log('Exception in getCategoryById: ${e.toString()}');
      rethrow;
    }
  }
}
