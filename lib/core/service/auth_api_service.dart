import 'dart:convert';
import 'package:deals/core/utils/logger.dart';

import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/models/user_model/user_model.dart';

class AuthApiService {
  final HttpClientService _http;

  AuthApiService({HttpClientService? http}) : _http = http ?? HttpClientService();
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
      final response = await _http.post(
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
        appLog('registerUser ✅  (${response.statusCode}) → ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      appLog('registerUser ❌  (${response.statusCode}) → ${response.body}');
      throw CustomException(
        'Error registering user: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      appLog('registerUser EXCEPTION → $e');
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

      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        appLog('sendOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          'Error sending OTP: ${response.statusCode} ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      appLog('sendOtp ✅  → $data');

      return UserEntity(
        id: data[BackendEndpoints.kId],
        token: '',
        uId: data[BackendEndpoints.kFirbaseUid],
        email: data[BackendEndpoints.keyEmail],
        fullName: data[BackendEndpoints.keyFullName],
        phone: data[BackendEndpoints.keyPhone],
      );
    } catch (e) {
      appLog('sendOtp EXCEPTION → $e');
      rethrow;
    }
  }

  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(BackendEndpoints.verifyOtp);

    try {
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.kOtp: otp,
        }),
      );

      if (response.statusCode != 200) {
        appLog('verifyOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          'Error verifying OTP: ${response.statusCode} ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      appLog('verifyOtp ✅  → $data');
      return data['message'] as String;
    } catch (e) {
      appLog('verifyOtp EXCEPTION → $e');
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
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.kToken: token}),
      );

      if (response.statusCode != 200) {
        appLog('sendOAuthToken ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
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
      appLog('sendOAuthToken ✅  → user: $userJson');
      return UserModel.fromJson(userJson);
    } catch (e) {
      appLog('sendOAuthToken EXCEPTION → $e');
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
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.keyPassword: password,
        }),
      );

      if (response.statusCode == 200) {
        appLog('loginUser ✅  → ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      // 401 with "Email not verified" → resend OTP & bubble custom error
      if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        if (data[BackendEndpoints.kMessage] == 'Email not verified') {
          appLog('loginUser: email not verified – resending OTP');
          await resendOtp(email: email);
          throw CustomException('Email not verified. OTP has been resent.');
        }
      }

      appLog('loginUser ❌  (${response.statusCode}) → ${response.body}');
      throw CustomException(
        'Error logging in: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      appLog('loginUser EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  RESEND OTP
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> resendOtp({required String email}) async {
    final url = Uri.parse(BackendEndpoints.resendOtp);

    try {
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        appLog('resendOtp ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(data['message'] as String? ?? 'Resend failed');
      }

      appLog('resendOtp ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      appLog('resendOtp EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  PASSWORD RESET / CHANGE
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> forgotPassword({required String email}) async {
    final url = Uri.parse(BackendEndpoints.forgotPassword);

    try {
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({BackendEndpoints.keyEmail: email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        appLog('forgotPassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          'Error in forgotPassword: ${response.statusCode} ${response.body}',
        );
      }

      appLog('forgotPassword ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      appLog('forgotPassword EXCEPTION → $e');
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
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({
          BackendEndpoints.keyEmail: email,
          BackendEndpoints.kOtp: otp,
          BackendEndpoints.kNewPassword: newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        appLog('resetPassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          'Error in resetPassword: ${response.statusCode} ${response.body}',
        );
      }

      appLog('resetPassword ✅  → ${data['message']}');
      return data['message'] as String;
    } catch (e) {
      appLog('resetPassword EXCEPTION → $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  LOGOUT
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> logout({required String firebaseUid}) async {
    final url = Uri.parse(BackendEndpoints.logout);

    try {
      final response = await _http.post(
        url,
        headers: BackendEndpoints.jsonHeaders,
        body: jsonEncode({'firebase_uid': firebaseUid}),
      );

      if (response.statusCode != 200) {
        appLog('logout ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          'Error in logout: ${response.statusCode} ${response.body}',
        );
      }

      appLog('logout ✅  → ${response.body}');
    } catch (e) {
      appLog('logout EXCEPTION → $e');
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
      final response = await _http.post(
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
        appLog('changePassword ❌  (${response.statusCode}) → ${response.body}');
        throw CustomException(
          data['message'] as String? ??
              'Error changing password: ${response.statusCode}',
        );
      }

      appLog('changePassword ✅  → ${data['message']}');
      return data['message'] as String? ?? 'Password updated';
    } catch (e) {
      appLog('changePassword EXCEPTION → $e');
      rethrow;
    }
  }
}
