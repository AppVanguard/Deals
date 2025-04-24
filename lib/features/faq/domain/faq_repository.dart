import 'dart:convert';
import 'package:deals/features/faq/data/faq_item.dart';
import 'package:flutter/services.dart';

abstract class FaqRepository {
  Future<List<FAQItem>> loadFaqs();
}

class JsonFaqRepository implements FaqRepository {
  @override
  Future<List<FAQItem>> loadFaqs() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/faq.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return (data['faqs'] as List)
        .map((e) => FAQItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
