import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackendEndpoints {
  // ───────────────────────── BASE ─────────────────────────
  static String baseUrl = dotenv.env['Base_Url'] ?? '';
  static String apiPath = "$baseUrl/api";

  // ──────────────────────── AUTH ──────────────────────────
  static String registerUser = "$apiPath/auth/register";
  static String verifyEmail = "$apiPath/auth/verify-email";
  static String oauth = "$apiPath/auth/oauth";
  static String loginUser = "$apiPath/auth/login";
  static String resendOtp = "$apiPath/auth/resend-otp";
  static String changePassword = "$apiPath/auth/change-password";
  static String resetPassword = "$apiPath/auth/reset-password";
  static String forgotPassword = "$apiPath/auth/forgot-password";
  static String logout = "$apiPath/auth/logout";
  static String verifyOtp = "$apiPath/auth/verify-otp";

  // ─────────────────────── RESOURCES ──────────────────────
  static String users = "$apiPath/users";
  static String stores = "$apiPath/stores";
  static String categories = "$apiPath/categories";
  static String coupons = "$apiPath/coupons";
  static String notifications = "$apiPath/notifications";
  static String notificationsRead = "$apiPath/notifications/read";
  static String notificationsAllow = "$apiPath/notifications/allow";
  static String notificationsPrevent = "$apiPath/notifications/prevent";
  static String bookmarks = "$apiPath/bookmarks";
  static String homeMobile = "$apiPath/home/mobile";

  // ─────────────────────── NEW ENDPOINT ───────────────────
  /// PATCH `/users/updateAfterRegister/:firebase_uid`
  /// *لا يحتاج إلى توكن مصادقة*.
  static String updateAfterRegister = "$apiPath/users/updateAfterRegister";

  // ───────────────────── COLLECTION NAMES ─────────────────
  static const String usersCollection = "users";

  // ────────────────────── JSON KEYS (req) ─────────────────
  static const String keyUid = "uid";
  static const String keyEmail = "email";
  static const String keyFullName = "full_name";
  static const String keyPhone = "phone";
  static const String keyPassword = "password";
  static const String kId = "id";
  static const String kOtp = "otp";
  static const String kToken = "token";
  static const String kJwtToken = "Jwttoken";
  static const String kMessage = "message";
  static const String kCountry = "country";
  static const String kCity = "city";
  static const String kDateOfBirth = "date_of_birth";
  static const String kGender = "gender";
  static const String kSearch = "search";
  static const String kPage = "page";
  static const String kLimit = "limit";
  static const String kSortField = "sortField";
  static const String kSortOrder = "sortOrder";
  static const String kCategoryId = "category";
  static const String kDiscountType = "discount_type";
  static const String kFirebaseUid = "firebase_uid";
  static const String kStore = "store";
  static const String kStoreId = "storeId";
  static const String kCurrentPassword = "currentPassword";
  static const String kNewPassword = "newPassword";

  // ────────────────────── JSON KEYS (res) ─────────────────
  static const String keyUserId = "userId";
  static const String kFirbaseUid = "firebase_uid";

  // ───────────────────────── HEADERS ──────────────────────
  static const String kAuthorization = "Authorization";
  static const String kContentType = "Content-Type";

  static const Map<String, String> jsonHeaders = {
    kContentType: 'application/json',
  };

  static Map<String, String> authJsonHeaders(String token) => {
        ...jsonHeaders,
        kAuthorization: 'Bearer $token',
      };
}
