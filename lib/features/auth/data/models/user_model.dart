class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  dynamic dataOfBirth;
  String? gender;
  String? country;
  String? city;
  String? firebaseUid;
  int? totalSavings;
  List<dynamic>? favoriteStores;
  bool? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.dataOfBirth,
    this.gender,
    this.country,
    this.city,
    this.firebaseUid,
    this.totalSavings,
    this.favoriteStores,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] as String?,
        fullName: json['full_name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        dataOfBirth: json['data_of_birth'] as dynamic,
        gender: json['gender'] as String?,
        country: json['country'] as String?,
        city: json['city'] as String?,
        firebaseUid: json['firebase_uid'] as String?,
        totalSavings: json['total_savings'] as int?,
        favoriteStores: json['favorite_stores'] as List<dynamic>?,
        isActive: json['is_active'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'data_of_birth': dataOfBirth,
        'gender': gender,
        'country': country,
        'city': city,
        'firebase_uid': firebaseUid,
        'total_savings': totalSavings,
        'favorite_stores': favoriteStores,
        'is_active': isActive,
        'deleted_at': deletedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
        'token': token,
      };
}
