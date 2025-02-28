class AnnouncementEntity {
  final String id;
  final String title;
  final String? imageUrl;
  // etc.

  const AnnouncementEntity({
    required this.id,
    required this.title,
    this.imageUrl,
  });
}
