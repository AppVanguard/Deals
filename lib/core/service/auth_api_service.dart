import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

class AuthApiService {
  /// Registers a new user.
  Future<Map<String, dynamic>> registerUser({
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
          BackendEndpoints.keyUid: "", // backend may generate uid
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.keyFullName: name,
          BackendEndpoints.keyPhone: phone,
          BackendEndpoints.keyPassword: password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('User registered successfully: ${response.statusCode} ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
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

  /// Sends an OTP to verify the email.
  Future<UserEntity> sendOtp({required String email, String? otp}) async {
    final url = Uri.parse(BackendEndpoints.verifyEmail);
    try {
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

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return UserEntity(
        uId: responseData[BackendEndpoints.kId],
        email: responseData[BackendEndpoints.keyEmail],
        name: responseData[BackendEndpoints.keyFullName],
        phone: responseData[BackendEndpoints.keyPhone],
      );
    } catch (e) {
      log('Exception in sendOtp: ${e.toString()}');
      rethrow;
    }
  }

  /// Sends an OAuth token to the backend.
  Future<void> sendOAuthToken({required String token}) async {
    final url = Uri.parse(BackendEndpoints.oauth);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
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

  /// Logs in the user via /auth/login.
  ///
  /// If the response status is 200, login is successful.
  /// If a 401 is returned with the message "Email not verified",
  /// it automatically triggers the OTP resend and throws an exception.
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(BackendEndpoints.loginUser); // e.g., "/auth/login"
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.keyPassword: password,
        }),
      );

      if (response.statusCode == 200) {
        log('Login successful: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == "Email not verified") {
          log('Email not verified, triggering OTP resend.');
          await resendOtp(email: email);
          throw Exception("Email not verified. OTP has been resent.");
        } else {
          log('Login error: ${response.statusCode} ${response.body}');
          throw Exception(
              "Error logging in: ${response.statusCode} ${response.body}");
        }
      } else {
        log('Login error: ${response.statusCode} ${response.body}');
        throw Exception(
            "Error logging in: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log('Exception in loginUser: ${e.toString()}');
      rethrow;
    }
  }

  /// Resends the OTP via /auth/resend-otp.
  ///
  /// This method sends only the email in the payload.
  Future<void> resendOtp({required String email}) async {
    final url =
        Uri.parse(BackendEndpoints.resendOtp); // e.g., "/auth/resend-otp"
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
        }),
      );

      if (response.statusCode == 200) {
        log('OTP resent successfully: ${response.body}');
      } else {
        log('Error resending OTP: ${response.statusCode} ${response.body}');
        throw Exception(
            "Error resending OTP: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log('Exception in resendOtp: ${e.toString()}');
      rethrow;
    }
  }
}
