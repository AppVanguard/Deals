// home_service.dart
import 'dart:convert';
import 'package:deals/core/utils/dev_log.dart';
import 'package:deals/features/home/data/models/home_model/home_model.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';

class HomeService {
  final HttpClientService _http;

  HomeService({HttpClientService? http}) : _http = http ?? HttpClientService();

  /// Retrieve home data from `/home/mobile` with pagination parameters
  Future<HomeModel> getHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
    required String token,
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
          await _http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
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
