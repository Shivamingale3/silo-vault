import 'package:local_auth/local_auth.dart';
import 'package:notes_vault/core/enums/security_enums.dart';

class BiometricAuth {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your notes',
        biometricOnly: true,
      );
      if (!authenticated) {
        throw Exception('Authentication failed');
      }
    } catch (e) {
      throw Exception('Error during authentication: $e');
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
