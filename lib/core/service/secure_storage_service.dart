import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define a constant key (you may want to keep these in your constants file)
const String kUserEntity = 'user_entity';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveUserEntity(String userJson) async {
    await _storage.write(key: kUserEntity, value: userJson);
  }

  static Future<String?> getUserEntity() async {
    return await _storage.read(key: kUserEntity);
  }

  static Future<void> deleteUserEntity() async {
    await _storage.delete(key: kUserEntity);
  }
}
