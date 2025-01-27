import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.name,
    required super.uId,
  });
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      email: user.email ?? '',
      uId: user.uid,
      name: user.displayName ?? '',
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      uId: json['uId'],
    );
  }
  factory UserModel.fromEntity(
    UserEntity userEntity,
  ) {
    return UserModel(
        email: userEntity.email, name: userEntity.name, uId: userEntity.uId);
  }
  toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
    };
  }
}
