import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

/// A data model to map UserEntity to/from external sources (e.g., Firebase).
class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.name,
    required super.uId,
    required super.phone,
  });

  /// Construct a `UserModel` from a Firebase [User] object.
  /// Note that Firebase user might not have `phone` or `displayName`.
  /// If those are required, default them to an empty string or handle separately.
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      email: user.email ?? '',
      uId: user.uid,
      name: user.displayName ?? '',
      phone:
          '', // Default to empty if you need phone from Auth (not always available).
    );
  }

  /// Convert a JSON map from Firestore to a `UserModel`.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      uId: json['uId'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  /// Construct a `UserModel` from a `UserEntity`.
  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      email: userEntity.email,
      name: userEntity.name,
      uId: userEntity.uId,
      phone: userEntity.phone,
    );
  }

  /// Convert this model into a map that can be stored in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }
}
