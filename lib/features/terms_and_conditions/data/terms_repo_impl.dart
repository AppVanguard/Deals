import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';

class TermsRepoImpl implements TermsRepo {
  const TermsRepoImpl();

  @override
  Future<List<String>> loadTerms() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/terms_and_conditions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<String>.from(data['terms'] as List);
  }
}
