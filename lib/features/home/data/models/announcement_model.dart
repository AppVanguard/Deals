import 'package:in_pocket/features/home/domain/entities/announcement_entity.dart';

class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.imageUrl,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
