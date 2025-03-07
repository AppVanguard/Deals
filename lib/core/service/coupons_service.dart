import 'dart:convert';
import 'dart:developer';

import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/features/coupons/data/models/coupons_model.dart';
import 'package:http/http.dart' as http;

class CouponsService {
  Future<CouponsModel> getAllCoupons({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
  }) async {
    final queryParameters = <String, String>{
      if (search != null) BackendEndpoints.kSearch: search,
      if (sortField != null) BackendEndpoints.kSortField: sortField,
      if (page != null) BackendEndpoints.kPage: page.toString(),
      if (limit != null) BackendEndpoints.kLimit: limit.toString(),
      if (sortOrder != null) BackendEndpoints.kSortOrder: sortOrder,
    };
    final url = Uri.parse(BackendEndpoints.coupons)
        .replace(queryParameters: queryParameters);
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return CouponsModel.fromJson(jsonMap);
      } else {
        log('Error fetching coupons: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Exception in getAllCoupons: ${e.toString()}');
      rethrow;
    }
  }

  Future<CouponsModel> getCouponById(String id) async {
    final url = Uri.parse('${BackendEndpoints.coupons}/$id');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return CouponsModel.fromJson(jsonMap);
      } else {
        log('Error fetching coupon by id: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch coupon by id: ${response.body}');
      }
    } catch (e) {
      log('Exception in getCouponById: ${e.toString()}');
      rethrow;
    }
  }
}
