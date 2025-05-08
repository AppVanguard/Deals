// lib/core/service/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:deals/core/entities/user_entity.dart';

const String kUserEntity = 'user_entity';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Save the signed-in user.
  static Future<void> saveUserEntity(UserEntity user) =>
      _storage.write(key: kUserEntity, value: user.toJson());

  /// Read the stored user, or `null` if none.
  static Future<UserEntity?> readUserEntity() async {
    final jsonString = await _storage.read(key: kUserEntity);
    return jsonString == null ? null : UserEntity.fromJson(jsonString);
  }

  /// Delete the stored user (e.g. on logout).
  static Future<void> deleteUserEntity() => _storage.delete(key: kUserEntity);

  // ◀── NEW HELPER ──────────────────────────────────────────────────────────▶

  /// Alias for [readUserEntity], named for clarity in your UI code.
  ///
  /// Usage:
  /// ```dart
  /// final user = await SecureStorageService.getCurrentUser();
  /// ```
  static Future<UserEntity?> getCurrentUser() => readUserEntity();
}
