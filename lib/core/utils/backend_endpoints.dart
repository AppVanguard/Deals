class BackendEndpoints {
  // Base URLs and API paths.
  static const String baseUrl = "https://inpocket-backend.onrender.com";
  static const String apiPath = "$baseUrl/api";

  // Auth endpoints.
  static const String registerUser = "$apiPath/auth/register";
  static const String verifyEmail = "$baseUrl/auth/verify-email";
  static const String oauth = "$baseUrl/auth/oauth";

  // Collection names.
  static const String usersCollection = "users";

  // JSON keys for request payloads.
  static const String keyUid = "uid";
  static const String keyEmail = "email";
  static const String keyFullName = "full_name";
  static const String keyPhone = "phone";
  static const String keyPassword = "password";

  // JSON keys for response payloads.
  static const String keyUserId = "userId";

  // Common Headers.
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
