import 'dart:convert';
import 'package:flutter/services.dart';

abstract class TermsRepository {
  Future<List<String>> loadTerms();
}

class JsonTermsRepository implements TermsRepository {
  @override
  Future<List<String>> loadTerms() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/terms_and_conditions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<String>.from(data['terms'] as List);
  }
}
