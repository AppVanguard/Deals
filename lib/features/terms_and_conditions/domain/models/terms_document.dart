import 'section.dart';

class TermsDocument {
  final List<Section> sections;

  TermsDocument(this.sections);

  factory TermsDocument.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'] as List<dynamic>;
    final secs =
        raw.map((e) => Section.fromJson(e as Map<String, dynamic>)).toList();
    return TermsDocument(secs);
  }
}
