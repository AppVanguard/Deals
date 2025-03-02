class BackendEndpoints {
  // Base URLs and API paths.
  static const String baseUrl = "https://inpocket-backend.onrender.com";
  static const String apiPath = "$baseUrl/api";

  // Auth endpoints.
  static const String registerUser = "$apiPath/auth/register";
  static const String verifyEmail = "$apiPath/auth/verify-email";
  static const String oauth = "$apiPath/auth/oauth";
  static const String loginUser = "$apiPath/auth/login";
  static const String resendOtp = "$apiPath/auth/resend-otp";
  static const String users = "$apiPath/users";
  static const String resetPassword = "$apiPath/auth/reset-password";
  static const String forgotPassword = "$apiPath/auth/forgot-password";
  static const String logout = "$apiPath/auth/logout";
  static const String verifyOtp = "$apiPath/auth/verify-otp";
// Home endpoints.
  static const String homeMobile = "$apiPath/home/mobile";
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
  // JSON keys for response payloads.
  static const String keyUserId = "userId";
  static const String kFirbaseUid = "firebase_uid";

  // Common Headers.
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
