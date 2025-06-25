import 'privacy_section.dart';

class PrivacyPolicyDocument {
  final List<PrivacySection> sections;

  PrivacyPolicyDocument(this.sections);

  factory PrivacyPolicyDocument.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'] as List<dynamic>;
    final secs = raw
        .map((e) => PrivacySection.fromJson(e as Map<String, dynamic>))
        .toList();
    return PrivacyPolicyDocument(secs);
  }
}
