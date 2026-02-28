import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes_vault/core/enums/app_enums.dart';

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> write(AppKeys key, String value) async {
    if (key == AppKeys.biometric) throw Exception("Invalid key");
    await _secureStorage.write(key: key.name, value: value);
  }

  static Future<void> setBiometricStatus(bool isEnabled) async {
    await _secureStorage.write(
      key: AppKeys.biometric.name,
      value: isEnabled.toString(),
    );
  }

  static Future<bool> getBiometricStatus() async {
    String? exists = await _secureStorage.read(key: AppKeys.biometric.name);
    return exists != null && exists == "true";
  }

  static Future<void> setAppPin(String pin) async {
    await write(AppKeys.appPin, BCrypt.hashpw(pin, BCrypt.gensalt()));
  }

  static Future<String?> read(AppKeys key) async {
    if (key == AppKeys.biometric) throw Exception("Invalid key");
    return await _secureStorage.read(key: key.name);
  }

  static Future<void> delete(AppKeys key) async {
    await _secureStorage.delete(key: key.name);
  }
}
