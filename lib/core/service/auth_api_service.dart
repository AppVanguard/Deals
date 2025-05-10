import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/models/user_model/user_model.dart';

class AuthApiService {
  // ──────────────────────────────────────────────────────────────────────────
  //  USER REGISTRATION
  // ──────────────────────────────────────────────────────────────────────────
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
          BackendEndpoints.keyUid: "",
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.keyFullName: name,
          BackendEndpoints.keyPhone: phone,
          BackendEndpoints.keyPassword: password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('registerUser ✅  (${response.statusCode}) → ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      log('registerUser ❌  (${response.statusCode}) → ${response.body}');
      throw CustomExeption(
        'Error registering user: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      log('registerUser EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  EMAIL / OTP
  // ──────────────────────────────────────────────────────────────────────────
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
        log('sendOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error sending OTP: ${response.statusCode} ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      log('sendOtp ✅  → $data');

      return UserEntity(
        id: data[BackendEndpoints.kId],
        token: '',
        uId: data[BackendEndpoints.kFirbaseUid],
        email: data[BackendEndpoints.keyEmail],
        fullName: data[BackendEndpoints.keyFullName],
        phone: data[BackendEndpoints.keyPhone],
      );
    } catch (e) {
      log('sendOtp EXCEPTION → $e');
      rethrow;
    }
  }

  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(BackendEndpoints.verifyOtp);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.kOtp: otp,
        }),
      );

      if (response.statusCode != 200) {
        log('verifyOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error verifying OTP: ${response.statusCode} ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      log('verifyOtp ✅  → $data');
      return data['message'] as String;
    } catch (e) {
      log('verifyOtp EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  OAUTH → JWT HANDSHAKE  **UPDATED**
  // ──────────────────────────────────────────────────────────────────────────
  ///
  /// Sends the Firebase ID-token (or other provider token) to `/auth/oauth`,
  /// receives the backend’s `{ Jwttoken, user }` envelope, injects the JWT into
  /// the nested `user` map under the key `token`, and returns a fully-populated
  /// [UserModel].
  ///
  Future<UserModel> sendOAuthToken({required String token}) async {
    final url = Uri.parse(BackendEndpoints.oauth);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.kToken: token}),
      );

      if (response.statusCode != 200) {
        log('sendOAuthToken ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error sending OAuth token: ${response.statusCode} ${response.body}',
        );
      }

      final Map<String, dynamic> body = jsonDecode(response.body);

      // — step 1: pull out the nested user map
      final Map<String, dynamic> userJson =
          Map<String, dynamic>.from(body['user'] as Map);

      // — step 2: inject the JWT under the key our `UserModel` expects
      userJson['token'] = body['Jwttoken'] as String;

      // — step 3: parse & return
      log('sendOAuthToken ✅  → user: $userJson');
      return UserModel.fromJson(userJson);
    } catch (e) {
      log('sendOAuthToken EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  CLASSIC EMAIL / PASSWORD LOGIN
  // ──────────────────────────────────────────────────────────────────────────
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
        log('loginUser ✅  → ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      // 401 with "Email not verified" → resend OTP & bubble custom error
      if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        if (data[BackendEndpoints.kMessage] == 'Email not verified') {
          log('loginUser: email not verified – resending OTP');
          await resendOtp(email: email);
          throw CustomExeption('Email not verified. OTP has been resent.');
        }
      }

      log('loginUser ❌  (${response.statusCode}) → ${response.body}');
      throw CustomExeption(
        'Error logging in: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      log('loginUser EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  RESEND OTP
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> resendOtp({required String email}) async {
    final url = Uri.parse(BackendEndpoints.resendOtp);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('resendOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(data['message'] as String? ?? 'Resend failed');
      }

      log('resendOtp ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      log('resendOtp EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  PASSWORD RESET / CHANGE
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> forgotPassword({required String email}) async {
    final url = Uri.parse(BackendEndpoints.forgotPassword);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('forgotPassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error in forgotPassword: ${response.statusCode} ${response.body}',
        );
      }

      log('forgotPassword ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      log('forgotPassword EXCEPTION → $e');
      rethrow;
    }
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
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

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('resetPassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error in resetPassword: ${response.statusCode} ${response.body}',
        );
      }

      log('resetPassword ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      log('resetPassword EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  LOGOUT
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> logout({required String firebaseUid}) async {
    final url = Uri.parse(BackendEndpoints.logout);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({'firebase_uid': firebaseUid}),
      );

      if (response.statusCode != 200) {
        log('logout ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          'Error in logout: ${response.statusCode} ${response.body}',
        );
      }

      log('logout ✅  → ${response.body}');
    } catch (e) {
      log('logout EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  CHANGE PASSWORD (AUTH REQUIRED)
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  }) async {
    final url = Uri.parse(BackendEndpoints.changePassword);

    try {
      final response = await http.post(
        url,
        headers: BackendEndpoints.authJsonHeaders(authToken),
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.kCurrentPassword: currentPassword,
          BackendEndpoints.kNewPassword: newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('changePassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomExeption(
          data['message'] as String? ??
              'Error changing password: ${response.statusCode}',
        );
      }

      log('changePassword ✅  → ${data['message']}');
      return data['message'] as String? ?? 'Password updated';
    } catch (e) {
      log('changePassword EXCEPTION → $e');
      rethrow;
    }
  }
}
