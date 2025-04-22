class AnnouncementEntity {
  final String id;
  final String title;
  final String? imageUrl;
  final String? description;
  final bool? isActive;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // etc.

  const AnnouncementEntity({
    this.description,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.id,
    required this.title,
    this.imageUrl,
  });
}
