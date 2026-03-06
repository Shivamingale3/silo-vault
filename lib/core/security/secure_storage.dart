import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:silo_vault/core/enums/app_enums.dart';

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();

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

  static Future<void> setMaxUnlockAttempts(int attempts) async {
    if (attempts < 3) {
      throw Exception("Invalid value for maximum failed unlock attempts!");
    }
    await _secureStorage.write(
      key: AppKeys.maxUnlockAttempts.toString(),
      value: attempts.toString(),
    );
  }

  static Future<int> getMaxUnlockAttempts() async {
    String? maxAttempts = await _secureStorage.read(
      key: AppKeys.maxUnlockAttempts.toString(),
    );

    if (maxAttempts == null) return 3;
    return int.parse(maxAttempts);
  }

  static Future<void> setAppPin(String pin) async {
    await write(AppKeys.appPin, BCrypt.hashpw(pin, BCrypt.gensalt()));
  }

  static Future<void> setLockoutTill(DateTime till) async {
    if (till.isBefore(DateTime.now()) ||
        till.isAtSameMomentAs(DateTime.now())) {
      throw Exception("Invalid lockout time");
    }

    await write(AppKeys.lockoutTill, till.toString());
  }

  static Future<DateTime> isLockedOut() async {
    String? till = await read(AppKeys.lockoutTill);
    if (till == null) {
      return DateTime.now();
    }
    return DateTime.parse(till);
  }

  static Future<int> getFailedAttempts() async {
    String? attempts = await read(AppKeys.failedAttempts);
    if (attempts == null) return 0;
    return int.parse(attempts);
  }

  static Future<void> setFailedAttempts(int attempts) async {
    await write(AppKeys.failedAttempts, attempts.toString());
  }

  static Future<void> clearLockout() async {
    await delete(AppKeys.failedAttempts);
    await delete(AppKeys.lockoutTill);
  }

  /// Returns auto-lock timeout in seconds. Default: 0 (immediate).
  static Future<int> getAutoLockTimeout() async {
    String? timeout = await read(AppKeys.autoLockTimeout);
    if (timeout == null) return 0;
    return int.parse(timeout);
  }

  static Future<void> setAutoLockTimeout(int seconds) async {
    await write(AppKeys.autoLockTimeout, seconds.toString());
  }

  static Future<String?> getAppTheme() async {
    return await read(AppKeys.appTheme);
  }

  static Future<void> setAppTheme(String theme) async {
    await write(AppKeys.appTheme, theme);
  }

  static Future<void> write(AppKeys key, String value) async {
    if (key == AppKeys.biometric) throw Exception("Invalid key");
    await _secureStorage.write(key: key.name, value: value);
  }

  static Future<String?> read(AppKeys key) async {
    if (key == AppKeys.biometric) throw Exception("Invalid key");
    return await _secureStorage.read(key: key.name);
  }

  static Future<void> delete(AppKeys key) async {
    await _secureStorage.delete(key: key.name);
  }
}
