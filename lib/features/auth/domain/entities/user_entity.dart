import 'dart:convert';

class UserEntity {
  final String uId;
  final String email;
  final String name;
  final String phone;
  final String token;
  final String id;

  UserEntity({
    required this.id,
    required this.token,
    required this.uId,
    required this.email,
    required this.name,
    required this.phone,
  });

  // Method to convert UserEntity to JSON string (for SharedPreferences).
  String toJson() {
    return '{"uId": "$uId", "email": "$email", "name": "$name", "phone": "$phone", "token": "$token", "id": "$id"}';
  }

  // Method to create a UserEntity from a JSON string (to load from SharedPreferences).
  factory UserEntity.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserEntity(
      id: json['id'],
      token: json['token'],
      uId: json['uId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
