import 'dart:convert';
import 'package:deals/features/faq/domain/models/faq_document.dart';
import 'package:deals/features/faq/domain/repos/faq_repository.dart';
import 'package:flutter/services.dart';

class JsonFaqRepository implements FaqRepository {
  const JsonFaqRepository();

  @override
  Future<FaqDocument> loadFaq() async {
    final jsonStr = await rootBundle.loadString('assets/json/faq.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    return FaqDocument.fromJson(data);
  }
}
