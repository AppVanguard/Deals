import 'store.dart';

class BookmarkData {
  String? id;
  String? user;
  String? firebaseUid;
  Store? store;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BookmarkData({
    this.id,
    this.user,
    this.firebaseUid,
    this.store,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BookmarkData.fromJson(Map<String, dynamic> json) => BookmarkData(
        id: json['_id'] as String?,
        user: json['user'] as String?,
        firebaseUid: json['firebase_uid'] as String?,
        store: json['store'] == null
            ? null
            : Store.fromJson(json['store'] as Map<String, dynamic>),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'firebase_uid': firebaseUid,
        'store': store?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}
