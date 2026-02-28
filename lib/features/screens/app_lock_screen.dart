import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/pin_action_buttons.dart';
import 'package:notes_vault/features/widgets/pin_input_section.dart';
import 'package:notes_vault/security/app_security.dart';
import 'package:notes_vault/security/biometric_auth.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String? errorMessage;
  bool hidePin = true;
  bool isProcessing = false;
  int _pinInputKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialCheck();
    });
  }

  Future<void> _initialCheck() async {
    if (!await AppSecurity.pinExists()) {
      if (!mounted) return;
      context.go(AppRoutes.pinSetup);
      return;
    }

    if (!mounted) return;
    if (await SecureStorage.getBiometricStatus()) {
      await _attemptBiometric();
    }
  }

  Future<void> _attemptBiometric() async {
    final result = await BiometricAuth.authenticate();
    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        context.go(AppRoutes.home);
      case BiometricResult.cancelled:
      case BiometricResult.failed:
        // User can fall back to PIN entry — no extra dialog needed
        break;
    }
  }

  Future<void> _verifyPin(String inputPin) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
      errorMessage = null;
    });

    try {
      final isValid = await AppSecurity.verifyPin(inputPin);

      if (!mounted) return;

      if (isValid) {
        context.go(AppRoutes.home);
      } else {
        setState(() {
          isProcessing = false;
          errorMessage = "Incorrect PIN";
          _pinInputKey++; // Force PinInput to rebuild & clear
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
        errorMessage = "Error verifying PIN";
        _pinInputKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Unlock Notes Vault",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            PinInputSection(
              key: ValueKey(_pinInputKey),
              step: 1,
              enabled: !isProcessing,
              obscurePin: hidePin,
              errorMessage: errorMessage,
              onPinComplete: _verifyPin,
            ),
            const SizedBox(height: 20),
            PinActionButtons(
              isProcessing: isProcessing,
              hidePin: hidePin,
              step: 1, // No reset button on lock screen
              onToggleVisibility: () {
                setState(() {
                  hidePin = !hidePin;
                });
              },
              onReset: () {}, // Unused with step 1
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: isProcessing ? null : _attemptBiometric,
              icon: const Icon(Icons.fingerprint),
              label: const Text("Use Biometric"),
            ),
            if (isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
