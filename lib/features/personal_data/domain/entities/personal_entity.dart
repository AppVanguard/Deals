import 'dart:convert';

class PersonalEntity {
  // ─── REQUIRED ───────────────────────────────────────────────────────────────
  final String id;
  final String uId; // maps firebaseUid
  final String fullName;
  final String email;

  // ─── OPTIONAL ───────────────────────────────────────────────────────────────
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? city;
  final int totalSavings;
  final List<dynamic> favoriteStores;
  final List<dynamic> bookmarks;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PersonalEntity({
    // required
    required this.id,
    required this.uId,
    required this.fullName,
    required this.email,

    // optional
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.city,
    this.totalSavings = 0,
    this.favoriteStores = const [],
    this.bookmarks = const [],
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonalEntity.fromJson(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return PersonalEntity(
      id: json['id'] as String,
      uId: json['uId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      totalSavings: (json['totalSavings'] as int?) ?? 0,
      favoriteStores: (json['favoriteStores'] as List<dynamic>?) ?? [],
      bookmarks: (json['bookmarks'] as List<dynamic>?) ?? [],
      isActive: (json['isActive'] as bool?) ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  String toJson() => jsonEncode({
        'id': id,
        'uId': uId,
        'fullName': fullName,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'country': country,
        'city': city,
        'totalSavings': totalSavings,
        'favoriteStores': favoriteStores,
        'bookmarks': bookmarks,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      });
}
