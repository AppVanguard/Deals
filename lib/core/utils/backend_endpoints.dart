import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackendEndpoints {
  // Base URLs and API paths.
  static String baseUrl = dotenv.env['Base_Url'] ?? '';
  static String apiPath = "$baseUrl/api";

  // Auth endpoints.
  static String registerUser = "$apiPath/auth/register";
  static String verifyEmail = "$apiPath/auth/verify-email";
  static String oauth = "$apiPath/auth/oauth";
  static String loginUser = "$apiPath/auth/login";
  static String resendOtp = "$apiPath/auth/resend-otp";
  static String users = "$apiPath/users";
  static String resetPassword = "$apiPath/auth/reset-password";
  static String forgotPassword = "$apiPath/auth/forgot-password";
  static String logout = "$apiPath/auth/logout";
  static String verifyOtp = "$apiPath/auth/verify-otp";
  static String stores = "$apiPath/stores";
  static String categories = "$apiPath/categories";
  static String coupons = "$apiPath/coupons";
  static String notifications = "$apiPath/notifications";
  static String notificationsRead = "$apiPath/notifications/read";
  static String notificationsAllow = "$apiPath/notifications/allow";
  static String notificationsPrevent = "$apiPath/notifications/prevent";
// Home endpoints.
  static String homeMobile = "$apiPath/home/mobile";
  // Collection names.
  static const String usersCollection = "users";

  // JSON keys for request payloads.
  static const String keyUid = "uid";
  static const String keyEmail = "email";
  static const String keyFullName = "full_name";
  static const String keyPhone = "phone";
  static const String keyPassword = "password";
  static const String kId = "id";
  static const String kOtp = "otp";
  static const String kToken = "token";
  static const String kMessage = "message";
  static const String kCountry = "country";
  static const String newPassword = "newPassword";
  static const String kCity = "city";
  static const String kDateOfBirth = "date_of_birth";
  static const String kGender = "gender";
  static const String kSearch = "search";
  static const String kPage = "page";
  static const String kLimit = "limit";
  static const String kSortField = 'sortField';
  static const String kSortOrder = 'sortOrder';
  static const String kCategoryId = 'category';
  static const String kDiscountType = 'discount_type';
  static const String kStoreId = 'store';
  // JSON keys for response payloads.
  static const String keyUserId = "userId";
  static const String kFirbaseUid = "firebase_uid";
  static const String kAuthorization = "Authorization";
  static const String kContentType = "Content-Type";
  // Common Headers.
  static const Map<String, String> jsonHeaders = {
    kContentType: 'application/json',
  };
  static Map<String, String> authJsonHeaders(String token) {
    return {
      ...jsonHeaders,
      // kAuthorization: 'Bearer $token',
    };
  }
}
