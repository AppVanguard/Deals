import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/service/database_service.dart';

class BackendStoreService implements DatabaseService {
  final String _baseUrl = "https://inpocket-backend.onrender.com/api";

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    Uri url;
    http.Response response;
    try {
      if (documentId != null) {
        // Using PUT to update or create a document at /api/{path}/{documentId}.
        url = Uri.parse('$_baseUrl/$path/$documentId');
        response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
      } else {
        // Using POST to create a new document at /api/{path}.
        url = Uri.parse('$_baseUrl/$path');
        response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        log('Error in addData: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error adding/updating data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Exception in addData: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String documentId,
  }) async {
    final url = Uri.parse('$_baseUrl/$path/$documentId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      log('Error in getData: ${response.statusCode} ${response.body}');
      throw Exception(
          'Error retrieving data: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    final url = Uri.parse('$_baseUrl/$path/$documentId');
    final response = await http.get(url);
    return response.statusCode == 200;
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('$_baseUrl/$path/$documentId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        log('Error in updateData: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error updating data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Exception in updateData: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    final url = Uri.parse('$_baseUrl/$path/$documentId');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        log('Error in deleteData: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error deleting data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Exception in deleteData: ${e.toString()}');
      rethrow;
    }
  }
}
