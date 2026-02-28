import 'package:bcrypt/bcrypt.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/security/secure_storage.dart';

class AppSecurity {
  static Future<bool> isEmulator() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice == false;
  }

  static Future<bool> pinExists() async {
    final pin = await SecureStorage.read(AppKeys.appPin);
    return pin != null && pin.isNotEmpty;
  }

  static Future<bool> verifyPin(String inputPin) async {
    final storedHash = await SecureStorage.read(AppKeys.appPin);
    if (storedHash == null) return false;
    return BCrypt.checkpw(inputPin, storedHash);
  }

  static Future<void> disableScreenShot() async {}
}
