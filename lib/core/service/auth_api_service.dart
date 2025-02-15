import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/errors/exception.dart';
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
          BackendEndpoints.keyUid: "", // Backend may generate uid.
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
        throw CustomExeption(
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
      final body = otp != null
          ? {BackendEndpoints.keyEmail: email, BackendEndpoints.kOtp: otp}
          : {BackendEndpoints.keyEmail: email};
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        log('Error in sendOtp: ${response.statusCode} ${response.body}');
        throw CustomExeption(
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
        body: jsonEncode({BackendEndpoints.kToken: token}),
      );
      if (response.statusCode != 200) {
        log('Error in sendOAuthToken: ${response.statusCode} ${response.body}');
        throw CustomExeption(
            'Error sending OAuth token: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in sendOAuthToken: ${e.toString()}');
      rethrow;
    }
  }

  /// Logs in the user.
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(BackendEndpoints.loginUser);
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
        if (responseData[BackendEndpoints.kMessage] == "Email not verified") {
          log('Email not verified, triggering OTP resend.');
          await resendOtp(email: email);
          throw CustomExeption("Email not verified. OTP has been resent.");
        } else {
          log('Login error: ${response.statusCode} ${response.body}');
          throw CustomExeption(
              "Error logging in: ${response.statusCode} ${response.body}");
        }
      } else {
        log('Login error: ${response.statusCode} ${response.body}');
        throw CustomExeption(
            "Error logging in: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log('Exception in loginUser: ${e.toString()}');
      rethrow;
    }
  }

  /// Resends the OTP.
  Future<String> resendOtp({required String email}) async {
    final url = Uri.parse(BackendEndpoints.resendOtp);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );
      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log('OTP sent successfully: ${response.body}');
        return responseJson['message'] as String;
      } else {
        log('Error resending OTP: ${response.statusCode} ${response.body}');
        throw CustomExeption(responseJson['message'] as String);
      }
    } catch (e) {
      log('Exception in resendOtp: ${e.toString()}');
      rethrow;
    }
  }

  /// Sends a forgot password request.
  Future<String> forgotPassword({required String email}) async {
    final url = Uri.parse(BackendEndpoints.forgotPassword);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );
      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log('Forgot password request successful: ${response.body}');
        return responseJson['message'] as String;
      } else {
        log('Error in forgotPassword: ${response.statusCode} ${response.body}');
        throw CustomExeption(
            'Error in forgotPassword: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in forgotPassword: ${e.toString()}');
      rethrow;
    }
  }

  /// Sends a reset password request.
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    log("In Service:  email: $email, otp: $otp, newPassword: $newPassword");
    final url = Uri.parse(BackendEndpoints.resetPassword);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.kOtp: otp,
          BackendEndpoints.newPassword: newPassword,
        }),
      );
      log("The encoded body: ${jsonEncode({
            BackendEndpoints.keyEmail: email,
            BackendEndpoints.kOtp: otp,
            BackendEndpoints.newPassword: newPassword,
          })}");
      final responseJson = jsonDecode(response.body);
      log("the response :  ${response.statusCode}");
      if (response.statusCode == 200) {
        log('Reset password successful: ${response.body}');
        return responseJson['message'] as String;
      } else {
        log('Error in resetPassword: ${response.statusCode} ${response.body}');
        throw CustomExeption(
            'Error in resetPassword: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in resetPassword: ${e.toString()}');
      rethrow;
    }
  }

  /// Logs out the user.
  Future<void> logout({required String firebaseUid}) async {
    final url = Uri.parse(BackendEndpoints.logout);
    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({'firebase_uid': firebaseUid}),
      );
      if (response.statusCode == 200) {
        log('Logout successful: ${response.body}');
      } else {
        log('Error in logout: ${response.statusCode} ${response.body}');
        throw CustomExeption(
            'Error in logout: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Exception in logout: ${e.toString()}');
      rethrow;
    }
  }
}
