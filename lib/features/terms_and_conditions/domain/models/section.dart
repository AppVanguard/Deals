class Section {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  Section({
    required this.title,
    List<String>? paragraphs,
    List<String>? bullets,
  })  : paragraphs = paragraphs ?? [],
        bullets = bullets ?? [];

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'] as String,
      paragraphs: (json['paragraphs'] as List<dynamic>?)?.cast<String>() ?? [],
      bullets: (json['bullets'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
