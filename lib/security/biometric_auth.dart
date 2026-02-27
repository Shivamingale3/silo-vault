import 'package:local_auth/local_auth.dart';

class BiometricAuth{

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
}