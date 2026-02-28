import 'package:flutter/material.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/biometric_dialogs.dart';
import 'package:notes_vault/features/widgets/biometric_option.dart';
import 'package:notes_vault/features/widgets/pin_action_buttons.dart';
import 'package:notes_vault/features/widgets/pin_input_section.dart';
import 'package:notes_vault/security/biometric_auth.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String pin = '';
  String confirmPin = '';
  String? errorMessage;
  int step = 1;
  bool hidePin = true;
  bool enabled = true;
  bool isProcessing = false;
  bool enableBiometric = false;
  BiometricAvailability biometricAvailability =
      BiometricAvailability.unavailable;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final availability = await BiometricAuth.biometricAvailability();

    if (!mounted) return;

    setState(() {
      biometricAvailability = availability;
    });
  }

  void resetPinSetup() {
    setState(() {
      enabled = true;
      isProcessing = false;
      pin = '';
      confirmPin = '';
      errorMessage = null;
      step = 1;
    });
  }

  void _resetProcessingState() {
    setState(() {
      isProcessing = false;
      enabled = true;
    });
  }

  Future<BiometricSetupResult> _attemptBiometricSetup() async {
    final result = await BiometricAuth.authenticate();

    if (!mounted) return BiometricSetupResult.skipped;

    switch (result) {
      case BiometricResult.success:
        await SecureStorage.setBiometricStatus(true);
        return BiometricSetupResult.success;

      case BiometricResult.cancelled:
      case BiometricResult.failed:
        final shouldRetry = await showBiometricRetryDialog(
          context,
          result == BiometricResult.cancelled
              ? "Biometric authentication was cancelled."
              : "Biometric authentication failed.",
        );

        if (shouldRetry == true) {
          return _attemptBiometricSetup();
        } else {
          await SecureStorage.setBiometricStatus(false);
          return BiometricSetupResult.skipped;
        }
    }
  }

  Future<void> _savePin() async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
      enabled = false;
      errorMessage = null;
    });

    final messenger = ScaffoldMessenger.of(context);

    try {
      if (enableBiometric) {
        if (biometricAvailability == BiometricAvailability.notEnrolled) {
          if (!mounted) return;
          showBiometricNotEnrolledDialog(
            context,
            onCancel: _resetProcessingState,
            onOpenSettings: _resetProcessingState,
          );
          return;
        }

        final setupResult = await _attemptBiometricSetup();

        if (!mounted) return;

        if (setupResult == BiometricSetupResult.success) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Biometric set successfully!")),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("PIN saved without biometric.")),
          );
        }
      } else {
        await SecureStorage.setBiometricStatus(false);
      }

      await SecureStorage.setAppPin(pin);

      if (!mounted) return;
      appRouter.replace(AppRoutes.appLock);
    } catch (e) {
      if (!mounted) return;
      _resetProcessingState();
      messenger.showSnackBar(
        SnackBar(
          content: Text("Error setting PIN: ${e.toString()}"),
          action: SnackBarAction(label: "Retry", onPressed: _savePin),
        ),
      );
    }
  }

  void _onPinComplete(String value) {
    if (step == 1) {
      setState(() {
        pin = value;
        step = 2;
        errorMessage = null;
      });
    } else {
      setState(() {
        confirmPin = value;
      });

      if (pin == value) {
        _savePin();
      } else {
        setState(() {
          errorMessage = "PINs do not match";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set up your PIN",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            PinInputSection(
              step: step,
              enabled: enabled,
              obscurePin: hidePin,
              errorMessage: errorMessage,
              onPinComplete: _onPinComplete,
            ),
            const SizedBox(height: 20),
            PinActionButtons(
              isProcessing: isProcessing,
              hidePin: hidePin,
              step: step,
              onToggleVisibility: () {
                setState(() {
                  hidePin = !hidePin;
                });
              },
              onReset: resetPinSetup,
            ),
            BiometricOption(
              enableBiometric: enableBiometric,
              isProcessing: isProcessing,
              biometricAvailability: biometricAvailability,
              onChanged: (val) {
                setState(() {
                  enableBiometric = val;
                });
              },
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
