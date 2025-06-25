class PrivacySection {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  PrivacySection({
    required this.title,
    List<String>? paragraphs,
    List<String>? bullets,
  })  : paragraphs = paragraphs ?? [],
        bullets = bullets ?? [];

  factory PrivacySection.fromJson(Map<String, dynamic> json) {
    return PrivacySection(
      title: json['title'] as String,
      paragraphs: (json['paragraphs'] as List<dynamic>?)?.cast<String>() ?? [],
      bullets: (json['bullets'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
