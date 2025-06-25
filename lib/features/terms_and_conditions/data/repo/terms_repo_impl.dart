import 'dart:convert';
import 'package:deals/features/terms_and_conditions/domain/models/terms_document.dart';
import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';
import 'package:flutter/services.dart';

class JsonTermsRepository implements TermsRepo {
  const JsonTermsRepository();

  @override
  Future<TermsDocument> loadTerms() async {
    final jsonStr =
        await rootBundle.loadString('assets/json/terms_and_conditions.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    return TermsDocument.fromJson(data);
  }
}
