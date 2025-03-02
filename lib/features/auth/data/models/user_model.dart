import 'package:firebase_auth/firebase_auth.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.name,
    required super.uId,
    required super.phone,
    required super.token,
  });

  // Construct a UserModel from a Firebase User object.
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      email: user.email ?? '',
      uId: user.uid,
      name: user.displayName ?? '',
      phone: '',
      token: '', // Default to empty if phone is not available.
    );
  }

  // Convert a Firestore JSON map to a UserModel.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      uId: json['uId'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // Convert this model to a map that can be stored in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
      'token': token,
    };
  }
}
