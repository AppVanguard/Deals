import 'dart:convert';
import 'package:flutter/services.dart';

abstract class PrivacyPolicyRepository {
  Future<List<String>> loadTerms();
}

class JsonPrivacyRepository implements PrivacyPolicyRepository {
  @override
  Future<List<String>> loadTerms() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/privacy_policy.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<String>.from(data['privacy'] as List);
  }
}
