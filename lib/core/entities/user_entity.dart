// lib/core/entities/user_entity.dart

import 'dart:convert';

/// Represents the signed‐in user and their personal data across the app.
class UserEntity {
  // ─── REQUIRED ───────────────────────────────────────────────────────────────
  final String id;
  final String token;
  final String uId; // firebaseUid
  final String fullName;
  final String email;
  final String phone;

  // ─── OPTIONAL / PERSONAL DATA ───────────────────────────────────────────────
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? city;
  final int totalSavings;
  final List<dynamic> favoriteStores;
  final List<dynamic> bookmarks;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserEntity({
    // required
    required this.id,
    required this.token,
    required this.uId,
    required this.fullName,
    required this.email,
    required this.phone,

    // optional
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.city,
    this.totalSavings = 0,
    this.favoriteStores = const [],
    this.bookmarks = const [],
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Serialize to JSON string (e.g. for SecureStorageService).
  String toJson() => jsonEncode({
        'id': id,
        'token': token,
        'uId': uId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
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

  /// Deserialize from JSON string.
  factory UserEntity.fromJson(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserEntity(
      id: map['id'] as String,
      token: map['token'] as String,
      uId: map['uId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      profileImageUrl: map['profileImageUrl'] as String?,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'] as String)
          : null,
      gender: map['gender'] as String?,
      country: map['country'] as String?,
      city: map['city'] as String?,
      totalSavings: (map['totalSavings'] as int?) ?? 0,
      favoriteStores: (map['favoriteStores'] as List<dynamic>?) ?? [],
      bookmarks: (map['bookmarks'] as List<dynamic>?) ?? [],
      isActive: map['isActive'] as bool?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}
