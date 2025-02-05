import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String _baseUrl = 'https://inpocket-backend.onrender.com';

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'full_name': name,
          'phone': phone,
          'password': password
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

  Future<void> signinUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('User registered successfully: ${response.statusCode} ${response.body}');
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        log('Error in registerUser: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error registering user: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in registerUser: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> sendOtp({required String email, required String otp}) async {
    final url = Uri.parse('$_baseUrl/auth/verify-email');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode != 200) {
        log('Error in sendOtp: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error sending OTP: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in sendOtp: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> sendOAuthToken({required String token}) async {
    final url = Uri.parse('$_baseUrl/api/auth/oauth');
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
}
