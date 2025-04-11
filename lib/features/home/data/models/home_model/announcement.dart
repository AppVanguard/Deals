import 'image.dart';

class Announcement {
  Image? image;
  String? id;
  String? title;
  String? description;
  bool? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Announcement({
    this.image,
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'image': image?.toJson(),
        '_id': id,
        'title': title,
        'description': description,
        'is_active': isActive,
        'deleted_at': deletedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'id': id,
      };
}
