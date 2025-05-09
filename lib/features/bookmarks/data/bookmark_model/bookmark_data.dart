import 'store.dart';

class BookmarkData {
  String? id;
  String? user;
  String? firebaseUid;

  /// If the API returns only the store-id string, we save it here.
  String? storeId;

  /// If the API expands the store object, we parse it here.
  Store? store;

  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BookmarkData({
    this.id,
    this.user,
    this.firebaseUid,
    this.storeId,
    this.store,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BookmarkData.fromJson(Map<String, dynamic> json) {
    final rawStore = json['store'];

    return BookmarkData(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      firebaseUid: json['firebase_uid'] as String?,

      // new flexible handling ↓
      storeId: rawStore is String ? rawStore : null,
      store: rawStore is Map<String, dynamic> ? Store.fromJson(rawStore) : null,

      createdAt:
          json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'firebase_uid': firebaseUid,
        'store': store?.toJson() ?? storeId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}
