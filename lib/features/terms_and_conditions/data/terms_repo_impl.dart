import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';

/// Loads the terms from a bundled JSON file.
class JsonTermsRepository implements TermsRepo {
  const JsonTermsRepository();

  @override
  Future<List<String>> loadTerms() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/terms_and_conditions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<String>.from(data['terms'] as List);
  }
}
