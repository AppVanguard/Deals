// lib/features/auth/data/models/user_model.dart

import 'package:deals/core/models/user_model/profile_image.dart';

class UserModel {
  // ─── PERSONAL-DATA FIELDS ─────────────────────────────────────────────────
  final ProfileImage? profileImage;
  final String? id;
  final String? fullName;
  final String? email;
  final dynamic dataOfBirth;
  final dynamic gender;
  final dynamic country;
  final dynamic city;
  final String? firebaseUid;
  final int? totalSavings;
  final List<dynamic>? favoriteStores;
  final List<dynamic>? bookmarks;
  final bool? isActive;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ─── ORIGINAL USER FIELDS ─────────────────────────────────────────────────
  final String? phone;
  final String? token;

  UserModel({
    // personal-data
    this.profileImage,
    this.id,
    this.fullName,
    this.email,
    this.dataOfBirth,
    this.gender,
    this.country,
    this.city,
    this.firebaseUid,
    this.totalSavings,
    this.favoriteStores,
    this.bookmarks,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    // original user
    this.phone,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        // personal-data
        profileImage: json['profile_image'] == null
            ? null
            : ProfileImage.fromJson(json['profile_image']),
        id: (json['_id'] ?? json['id']) as String?,
        fullName: json['full_name'] as String?,
        email: json['email'] as String?,
        dataOfBirth: json['data_of_birth'],
        gender: json['gender'],
        country: json['country'],
        city: json['city'],
        firebaseUid: json['firebase_uid'] as String?,
        totalSavings: json['total_savings'] as int?,
        favoriteStores: json['favorite_stores'] as List<dynamic>?,
        bookmarks: json['bookmarks'] as List<dynamic>?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        // original user
        phone: json['phone'] as String?,
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        // personal-data
        'profile_image': profileImage?.toJson(),
        '_id': id,
        'full_name': fullName,
        'email': email,
        'data_of_birth': dataOfBirth,
        'gender': gender,
        'country': country,
        'city': city,
        'firebase_uid': firebaseUid,
        'total_savings': totalSavings,
        'favorite_stores': favoriteStores,
        'bookmarks': bookmarks,
        'is_active': isActive,
        'deleted_at': deletedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        // original user
        'phone': phone,
        'token': token,
      };
}
