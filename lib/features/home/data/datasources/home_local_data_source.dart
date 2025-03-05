// home_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deals/features/home/data/models/home_model.dart';

class HomeLocalDataSource {
  static const String _cacheKey = 'cached_home_data';

  final SharedPreferences prefs;

  HomeLocalDataSource(this.prefs);

  Future<void> cacheHomeData(HomeModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString(_cacheKey, jsonString);
  }

  HomeModel? getCachedHomeData() {
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    return HomeModel.fromJson(jsonDecode(jsonString));
  }

  Future<void> clearCache() async {
    await prefs.remove(_cacheKey);
  }
}
