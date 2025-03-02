class Announcement {
  String? id;
  String? title;
  String? description;
  bool? isActive;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? v;

  Announcement({
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
        id: json['_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt:
            json['createdAt'] == null ? null : json['createdAt'] as String,
        updatedAt:
            json['updatedAt'] == null ? null : json['updatedAt'] as String,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'is_active': isActive,
        'deleted_at': deletedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'id': id,
      };
}
