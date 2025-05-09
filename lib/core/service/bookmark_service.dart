import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_data.dart';

class BookmarkService {
  final http.Client _http;
  BookmarkService([http.Client? client]) : _http = client ?? http.Client();

  /*──────────────────────────── GET all ───────────────────────────*/
  static const _kPageNumber = 'PageNumber';
  static const _kPageSize = 'PageSize';

  Future<BookmarkModel> getUserBookmarks({
    required String firebaseUid,
    required String token,
    required int page,
    required int limit,
    String search = '',
    List<String> categories = const [],
    bool hasCoupons = false,
    bool hasCashback = false,
    String sortOrder = 'asc',
  }) async {
    final qp = <String, String>{
      _kPageNumber: '$page',
      _kPageSize: '$limit',
      'sortOrder': sortOrder,
      'hasCoupons': '$hasCoupons',
      'hasCashback': '$hasCashback',
      if (search.isNotEmpty) 'search': search,
      if (categories.isNotEmpty) 'categories': categories.join(','),
    };

    final uri = Uri.parse('${BackendEndpoints.bookmarks}/$firebaseUid')
        .replace(queryParameters: qp);

    final res = await _http.get(
      uri,
      headers: BackendEndpoints.authJsonHeaders(token),
    );

    if (res.statusCode != 200) {
      log('Error fetching bookmarks ${res.statusCode}: ${res.body}');
      throw Exception('Failed to load bookmarks');
    }

    return BookmarkModel.fromJson(jsonDecode(res.body));
  }

  /*──────────────────────────── POST one ──────────────────────────*/
  Future<BookmarkData> createBookmark({
    required String firebaseUid,
    required String storeId,
    required String token,
  }) async {
    final uri = Uri.parse(BackendEndpoints.bookmarks);
    final body = jsonEncode({
      BackendEndpoints.kFirebaseUid: firebaseUid,
      BackendEndpoints.kStoreId: storeId,
    });

    final res = await _http.post(
      uri,
      headers: BackendEndpoints.authJsonHeaders(token),
      body: body,
    );

    if (res.statusCode != 201) {
      log('Error creating bookmark ${res.statusCode}: ${res.body}');
      throw Exception('Failed to create bookmark');
    }

    /// The backend **sometimes** returns the full object,
    /// and **sometimes only a plain JSON string** containing the new id.
    final decoded = jsonDecode(res.body);

    if (decoded is Map<String, dynamic>) {
      // full bookmark json → happy path
      return BookmarkData.fromJson(decoded);
    }

    if (decoded is String) {
      // just the bookmark id → wrap it so upper layers don’t crash
      return BookmarkData(id: decoded);
    }

    // any other format → log and crash upward
    throw Exception(
      'Unexpected response when creating bookmark: ${res.body}',
    );
  }

  /*─────────────────────────── DELETE one ─────────────────────────*/
  Future<void> deleteBookmark({
    required String bookmarkId,
    required String token,
  }) async {
    final uri = Uri.parse('${BackendEndpoints.bookmarks}/$bookmarkId');
    final res = await _http.delete(
      uri,
      headers: BackendEndpoints.authJsonHeaders(token),
    );

    if (res.statusCode != 204) {
      log('Error deleting bookmark ${res.statusCode}: ${res.body}');
      throw Exception('Failed to delete bookmark');
    }
  }
}
