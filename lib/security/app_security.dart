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
}
