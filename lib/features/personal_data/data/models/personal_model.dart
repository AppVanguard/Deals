import 'profile_image.dart';

class PersonalModel {
  ProfileImage? profileImage;
  String? id;
  String? fullName;
  String? email;
  dynamic dataOfBirth;
  dynamic gender;
  dynamic country;
  dynamic city;
  String? firebaseUid;
  int? totalSavings;
  List<dynamic>? favoriteStores;
  List<dynamic>? bookmarks;
  bool? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  PersonalModel({
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
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) => PersonalModel(
        profileImage: json['profile_image'] == null
            ? null
            : ProfileImage.fromJson(
                json['profile_image'] as Map<String, dynamic>),
        fullName: json['full_name'] as String?,
        email: json['email'] as String?,
        dataOfBirth: json['data_of_birth'] as dynamic,
        gender: json['gender'] as dynamic,
        country: json['country'] as dynamic,
        city: json['city'] as dynamic,
        firebaseUid: json['firebase_uid'] as String?,
        totalSavings: json['total_savings'] as int?,
        favoriteStores: json['favorite_stores'] as List<dynamic>?,
        bookmarks: json['bookmarks'] as List<dynamic>?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'profile_image': profileImage?.toJson(),
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
        'id': id,
      };
}
