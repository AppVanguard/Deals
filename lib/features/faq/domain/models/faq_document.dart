import 'faq_section.dart';

class FaqDocument {
  final List<FaqSection> sections;
  FaqDocument(this.sections);

  factory FaqDocument.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'] as List<dynamic>;
    final list =
        raw.map((e) => FaqSection.fromJson(e as Map<String, dynamic>)).toList();
    return FaqDocument(list);
  }
}
