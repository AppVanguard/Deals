import 'dart:convert';

class UserEntity {
  final String uId;
  final String email;
  final String name;
  final String phone;

  UserEntity({
    required this.uId,
    required this.email,
    required this.name,
    required this.phone,
  });

  // Method to convert UserEntity to JSON string (for SharedPreferences).
  String toJson() {
    return '{"uId": "$uId", "email": "$email", "name": "$name", "phone": "$phone"}';
  }

  // Method to create a UserEntity from a JSON string (to load from SharedPreferences).
  factory UserEntity.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserEntity(
      uId: json['uId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
