import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/core/models/user_model/user_model.dart';

class UserService {
  /// Retrieves a single user by id from GET /users/:id
  Future<UserModel> getUserById(String id, String token) async {
    final url = Uri.parse('${BackendEndpoints.users}/$id');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.authJsonHeaders(token));
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(jsonMap);
      } else {
        log('Error fetching user by id: '
            '${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch user: ${response.body}');
      }
    } catch (e) {
      log('Exception in getUserById: ${e.toString()}');
      rethrow;
    }
  }

  /// Updates any subset of the user's editable fields via PATCH /users/:id.
  /// Only non-null parameters will be sent in the body.
  Future<UserModel> updateUserData({
    required String id,
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String token,
  }) async {
    final url = Uri.parse('${BackendEndpoints.users}/$id');
    final body = <String, dynamic>{};

    if (fullName != null) body['full_name'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (country != null) body['country'] = country;
    if (city != null) body['city'] = city;
    if (dateOfBirth != null) body['data_of_birth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;

    try {
      final response = await http.patch(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(jsonMap);
      } else {
        log('Error updating user: '
            '${response.statusCode} ${response.body}');
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (e) {
      log('Exception in updateUserData: ${e.toString()}');
      rethrow;
    }
  }

  /// Deletes a user by their Firebase UID via DELETE /users/:firebaseUid
  /// and returns the server's success message.
  Future<String> deleteUserByFirebaseUid(
      String firebaseUid, String token) async {
    final url = Uri.parse('${BackendEndpoints.users}/$firebaseUid');
    try {
      final response = await http.delete(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
      );
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonMap['message'] as String;
      } else {
        log('Error deleting user: '
            '${response.statusCode} ${response.body}');
        throw Exception('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      log('Exception in deleteUserByFirebaseUid: ${e.toString()}');
      rethrow;
    }
  }
}
