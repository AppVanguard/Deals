import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

class AuthApiService {
  Future<Map<String, dynamic>> registerUser({
    // Note: uid is not passed if you let your backend generate it,
    // but if needed, include it as a parameter.
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse(BackendEndpoints.registerUser);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyUid:
              "", // Optionally leave empty if backend creates uid.
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.keyFullName: name,
          BackendEndpoints.keyPhone: phone,
          BackendEndpoints.keyPassword: password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('User registered successfully: ${response.statusCode} ${response.body}');
        final userInfo = jsonDecode(response.body) as Map<String, dynamic>;
        return userInfo;
      } else {
        log('Error in registerUser: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error registering user: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in registerUser: ${e.toString()}');
      rethrow;
    }
  }

  Future<UserEntity> sendOtp({required String email, String? otp}) async {
    final url = Uri.parse(BackendEndpoints.verifyEmail);
    try {
      // Include the OTP in the payload if provided.
      final body =
          otp != null ? {'email': email, 'otp': otp} : {'email': email};
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        log('Error in sendOtp: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error sending OTP: ${response.statusCode} ${response.body}');
      }

      // Parse the response body to create a UserEntity.
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Map the "id" field from the response to the UserEntity's uId,
      // and "full_name" to the name.
      return UserEntity(
        uId: responseData[
            BackendEndpoints.kId], // using "id" instead of "userId"
        email: responseData[BackendEndpoints.keyEmail],
        name: responseData[BackendEndpoints.keyFullName],
        phone: responseData[BackendEndpoints.keyPhone],
      );
    } catch (e) {
      log('Exception in sendOtp: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> sendOAuthToken({required String token}) async {
    final url = Uri.parse(BackendEndpoints.oauth);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );
      if (response.statusCode != 200) {
        log('Error in sendOAuthToken: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error sending OAuth token: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in sendOAuthToken: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> signinUser({
    required String email,
    required String password,
  }) async {
    // Implement sign in API if your backend requires it.
    // For example, you can call an endpoint like: "$BackendEndpoints.apiPath/auth/signin"
    // Here we leave it as a placeholder.
    // final url = Uri.parse('$_baseUrl/api/auth/signin');
    // ...
  }
}
