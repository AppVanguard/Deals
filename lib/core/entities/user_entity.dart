import 'dart:convert';

/// Represents the signed-in user and their personal data across the app.
class UserEntity {
  // ─── REQUIRED ──────────────────────────────────────────────────────────
  final String id;
  final String token;
  final String uId; // firebaseUid
  final String fullName;
  final String email;
  final String phone;

  // ─── OPTIONAL / PERSONAL DATA ──────────────────────────────────────────
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

  const UserEntity({
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

  // ───────────────────────── copyWith ──────────────────────────
  UserEntity copyWith({
    String? id,
    String? token,
    String? uId,
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? city,
    int? totalSavings,
    List<dynamic>? favoriteStores,
    List<dynamic>? bookmarks,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      token: token ?? this.token,
      uId: uId ?? this.uId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      totalSavings: totalSavings ?? this.totalSavings,
      favoriteStores: favoriteStores ?? this.favoriteStores,
      bookmarks: bookmarks ?? this.bookmarks,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ────────────────────── JSON helpers ────────────────────────
  String toJson() => jsonEncode(_toMap());

  Map<String, dynamic> _toMap() => {
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
      };

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
          ? DateTime.parse(map['dateOfBirth'])
          : null,
      gender: map['gender'] as String?,
      country: map['country'] as String?,
      city: map['city'] as String?,
      totalSavings: (map['totalSavings'] as int?) ?? 0,
      favoriteStores: (map['favoriteStores'] as List<dynamic>?) ?? [],
      bookmarks: (map['bookmarks'] as List<dynamic>?) ?? [],
      isActive: map['isActive'] as bool?,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}
