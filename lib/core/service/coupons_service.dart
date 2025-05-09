import 'dart:convert';
import 'dart:developer';

import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/features/coupons/data/models/coupons_data.dart';
import 'package:deals/features/coupons/data/models/coupons_model.dart';
import 'package:http/http.dart' as http;

class CouponsService {
  Future<CouponsModel> getAllCoupons({
    String? search,
    String? sortField = "title",
    int? page,
    int? limit,
    String? sortOrder = "asc",
    String? category,
    String? discountType,
    String? storeId,
    required String token,
  }) async {
    final queryParameters = <String, String>{
      if (search != null) BackendEndpoints.kSearch: search,
      if (sortField != null) BackendEndpoints.kSortField: sortField,
      if (page != null) BackendEndpoints.kPage: page.toString(),
      if (limit != null) BackendEndpoints.kLimit: limit.toString(),
      if (sortOrder != null) BackendEndpoints.kSortOrder: sortOrder,
      if (category != null) BackendEndpoints.kCategoryId: category,
      if (discountType != null) BackendEndpoints.kDiscountType: discountType,
      if (storeId != null) BackendEndpoints.kStore: storeId,
    };
    final url = Uri.parse(BackendEndpoints.coupons)
        .replace(queryParameters: queryParameters);
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
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

  Future<CouponsModel> getCouponById(String id, String token) async {
    final url = Uri.parse('${BackendEndpoints.coupons}/$id');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final singleCoupon = CouponsData.fromJson(jsonMap);
        return CouponsModel(
          data: [singleCoupon],
        );
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
