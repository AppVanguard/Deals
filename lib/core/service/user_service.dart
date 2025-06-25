import 'dart:convert';
import 'package:deals/core/utils/logger.dart';

import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';
import 'package:deals/core/models/user_model/user_model.dart';

class UserService {
  final HttpClientService _http;

  UserService({HttpClientService? http}) : _http = http ?? HttpClientService();

  /* ─────────────── GET USER BY ID ──────────────────────── */
  Future<UserModel> getUserById(String id, String token) async {
    final url = Uri.parse('${BackendEndpoints.users}/$id');
    try {
      final res = await _http.get(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
      );
      if (res.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(res.body));
      } else {
        appLog('Error fetching user by id: ${res.statusCode} ${res.body}');
        throw Exception('Failed to fetch user: ${res.body}');
      }
    } catch (e) {
      appLog('Exception in getUserById: $e');
      rethrow;
    }
  }

  /* ─────────────── UPDATE USER (AUTH) ──────────────────── */
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
    if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;

    try {
      final res = await _http.patch(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(res.body));
      } else {
        appLog('Error updating user: ${res.statusCode} ${res.body}');
        throw Exception('Failed to update user: ${res.body}');
      }
    } catch (e) {
      appLog('Exception in updateUserData: $e');
      rethrow;
    }
  }

  /* ────── UPDATE AFTER REGISTER (NO-AUTH) ──────────────── */
  Future<UserModel> updateUserAfterRegister({
    required String firebaseUid,
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    final url =
        Uri.parse('${BackendEndpoints.updateAfterRegister}/$firebaseUid');

    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (country != null) body['country'] = country;
    if (city != null) body['city'] = city;
    if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;

    try {
      final res = await _http.patch(
        url,
        headers: BackendEndpoints.jsonHeaders, // no auth token
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(res.body));
      } else {
        appLog('Error updateAfterRegister: ${res.statusCode} ${res.body}');
        throw Exception('Failed to update user after register: ${res.body}');
      }
    } catch (e) {
      appLog('Exception in updateUserAfterRegister: $e');
      rethrow;
    }
  }

  /* ─────────────── DELETE USER ─────────────────────────── */
  Future<String> deleteUserByFirebaseUid(
      String firebaseUid, String token) async {
    final url = Uri.parse('${BackendEndpoints.users}/$firebaseUid');
    try {
      final res = await _http.delete(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
      );
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map<String, dynamic>)['message'];
      } else {
        appLog('Error deleting user: ${res.statusCode} ${res.body}');
        throw Exception('Failed to delete user: ${res.body}');
      }
    } catch (e) {
      appLog('Exception in deleteUserByFirebaseUid: $e');
      rethrow;
    }
  }
}
