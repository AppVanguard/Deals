import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/data/models/user_model.dart';

class UserService {
  /// Retrieves all users from the /users endpoint.
  Future<List<UserEntity>> getAllUsers() async {
    final url = Uri.parse(BackendEndpoints.users);
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        // Expecting the API returns a JSON array of user objects.
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<UserEntity> users = jsonList
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return users;
      } else {
        log('Error fetching all users: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      log('Exception in getAllUsers: ${e.toString()}');
      rethrow;
    }
  }

  /// Retrieves a single user by their id from /users/:id endpoint.
  Future<UserEntity> getUserById(String id) async {
    final url = Uri.parse('${BackendEndpoints.users}/$id');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return UserModel.fromJson(jsonMap);
      } else {
        log('Error fetching user by id: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch user: ${response.body}');
      }
    } catch (e) {
      log('Exception in getUserById: ${e.toString()}');
      rethrow;
    }
  }

  /// Updates user data using a PATCH request to /users/:id.
  ///
  /// Required fields:
  /// - [fullName] (mapped to "full_name" in the request body)
  /// - [phone]
  ///
  /// Optional fields:
  /// - [country], [city], [dateOfBirth], [gender]
  ///
  /// Only provided optional fields will be sent.
  Future<UserEntity> updateUserData({
    required String id,
    required String fullName,
    required String phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    final url = Uri.parse('${BackendEndpoints.users}/$id');
    final Map<String, dynamic> body = {
      "full_name": fullName,
      "phone": phone,
    };

    // Include optional fields if provided.
    if (country != null) body["country"] = country;
    if (city != null) body["city"] = city;
    if (dateOfBirth != null) body["date_of_birth"] = dateOfBirth;
    if (gender != null) body["gender"] = gender;

    try {
      final response = await http.patch(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return UserModel.fromJson(jsonMap);
      } else {
        log('Error updating user data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (e) {
      log('Exception in updateUserData: ${e.toString()}');
      rethrow;
    }
  }
}
