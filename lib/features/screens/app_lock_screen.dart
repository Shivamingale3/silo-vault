import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/security/app_security.dart';
import 'package:notes_vault/security/biometric_auth.dart';
import 'package:notes_vault/core/enums/security_enums.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometrics();
    });
  }

  Future<void> _checkBiometrics() async {
    if (!await AppSecurity.pinExists()) {
      if (!mounted) return;
      context.go(AppRoutes.pinSetup);
      return; // Don't fall through to biometric check
    }

    if (!mounted) return;
    if (await SecureStorage.getBiometricStatus()) {
      final result = await BiometricAuth.authenticate();
      if (!mounted) return;
      if (result == BiometricResult.success) {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Text("App Lock Screem", style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
