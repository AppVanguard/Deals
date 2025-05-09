import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/core/utils/query_encoder.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_data.dart';

class BookmarkService {
  final http.Client _http;
  BookmarkService([http.Client? client]) : _http = client ?? http.Client();

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
    String sortOrder = 'asc', // asc | desc
  }) async {
    final qp = <String, String>{
      _kPageNumber: '$page',
      _kPageSize: '$limit',
      'sortOrder': sortOrder,
      'hasCoupons': boolToStr(hasCoupons),
      'hasCashback': boolToStr(hasCashback),
      if (search.isNotEmpty) 'search': search,
      if (categories.isNotEmpty) 'categories': categories.join(','),
    };

    final uri = Uri.parse('${BackendEndpoints.bookmarks}/$firebaseUid')
        .replace(queryParameters: qp);

    try {
      final res = await _http.get(
        uri,
        headers: BackendEndpoints.authJsonHeaders(token),
      );
      if (res.statusCode == 200) {
        return BookmarkModel.fromJson(jsonDecode(res.body));
      }
      log('Error ${res.statusCode}: ${res.body}');
      throw Exception('Failed to load bookmarks');
    } catch (e) {
      log('Exception in getUserBookmarks: $e');
      rethrow;
    }
  }

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

    if (res.statusCode == 201) {
      return BookmarkData.fromJson(jsonDecode(res.body));
    }
    log('Error creating bookmark ${res.statusCode}: ${res.body}');
    throw Exception('Failed to create bookmark');
  }

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
