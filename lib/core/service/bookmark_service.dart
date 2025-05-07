import 'dart:convert';
import 'dart:developer';

import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_data.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';

import 'package:http/http.dart' as http;

class BookmarkService {
  final http.Client _http;
  BookmarkService([http.Client? client]) : _http = client ?? http.Client();

  /// 1) GET /bookmarks/:firebase_uid
  Future<BookmarkModel> getUserBookmarks(
      String firebaseUid, String token) async {
    final uri = Uri.parse('${BackendEndpoints.bookmarks}/$firebaseUid');
    try {
      final resp = await _http.get(
        uri,
        headers: BackendEndpoints.authJsonHeaders(token),
      );
      if (resp.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(resp.body);
        return BookmarkModel.fromJson(jsonMap);
      } else {
        log('Error fetching bookmarks (${resp.statusCode}): ${resp.body}');
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      log('Exception in getUserBookmarks: $e');
      rethrow;
    }
  }

  /// 2) POST /bookmarks
  ///    body: { "firebase_uid": "...", "storeId": "..." }
  Future<BookmarkData> createBookmark({
    required String firebaseUid,
    required String storeId,
    required String token,
  }) async {
    final uri = Uri.parse(BackendEndpoints.bookmarks);
    final payload = jsonEncode({
      'firebase_uid': firebaseUid,
      'storeId': storeId,
    });

    try {
      final resp = await _http.post(
        uri,
        headers: BackendEndpoints.authJsonHeaders(token),
        body: payload,
      );
      if (resp.statusCode == 201) {
        final Map<String, dynamic> jsonMap = jsonDecode(resp.body);
        return BookmarkData.fromJson(jsonMap);
      } else {
        log('Error creating bookmark (${resp.statusCode}): ${resp.body}');
        throw Exception('Failed to create bookmark');
      }
    } catch (e) {
      log('Exception in createBookmark: $e');
      rethrow;
    }
  }

  /// 3) DELETE /bookmarks/:id
  Future<void> deleteBookmark(String id, String token) async {
    final uri = Uri.parse('${BackendEndpoints.bookmarks}/$id');
    try {
      final resp = await _http.delete(uri,
          headers: BackendEndpoints.authJsonHeaders(token));
      if (resp.statusCode != 204) {
        log('Error deleting bookmark (${resp.statusCode}): ${resp.body}');
        throw Exception('Failed to delete bookmark');
      }
    } catch (e) {
      log('Exception in deleteBookmark: $e');
      rethrow;
    }
  }
}
