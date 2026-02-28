import 'package:local_auth/local_auth.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:app_settings/app_settings.dart';

class BiometricAuth {
  static final LocalAuthentication auth = LocalAuthentication();

  static void openBiometricSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.security);
  }

  static Future<BiometricResult> authenticate() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your notes',
        biometricOnly: true,
      );
      return authenticated
          ? BiometricResult.success
          : BiometricResult.cancelled;
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled ||
          e.code == LocalAuthExceptionCode.userRequestedFallback) {
        return BiometricResult.cancelled;
      }
      return BiometricResult.failed;
    } catch (e) {
      return BiometricResult.failed;
    }
  }

  static Future<BiometricAvailability> biometricAvailability() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      if (!isSupported) {
        return BiometricAvailability.unavailable;
      }

      final canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        return BiometricAvailability.unavailable;
      }

      final biometrics = await auth.getAvailableBiometrics();

      if (biometrics.isEmpty) {
        return BiometricAvailability.notEnrolled;
      }

      return BiometricAvailability.available;
    } catch (e) {
      return BiometricAvailability.unavailable;
    }
  }
}
