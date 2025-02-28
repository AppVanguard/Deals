// home_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/home/data/models/home_model.dart';

class HomeService {
  /// Retrieve home data from `/home/mobile` with pagination parameters
  Future<HomeModel> getHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
  }) async {
    final url = Uri.parse(BackendEndpoints.homeMobile).replace(
      queryParameters: {
        'announcementsPage': announcementsPage.toString(),
        'announcementsCount': announcementsCount.toString(),
        'storesPage': storesPage.toString(),
        'storesCount': storesCount.toString(),
        'couponsPage': couponsPage.toString(),
        'couponsCount': couponsCount.toString(),
      },
    );

    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final homeModel = HomeModel.fromJson(jsonMap);
        return homeModel;
      } else {
        log('Error fetching home data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch home data: ${response.body}');
      }
    } catch (e) {
      log('Exception in getHomeData: ${e.toString()}');
      rethrow;
    }
  }
}
