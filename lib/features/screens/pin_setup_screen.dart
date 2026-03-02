import 'package:flutter/material.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/biometric_dialogs.dart';
import 'package:notes_vault/features/widgets/pin_setup_view.dart';
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

  void _resetProcessingState() {
    setState(() {
      isProcessing = false;
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

  void _onDigitTap(String digit) {
    if (isProcessing) return;
    setState(() {
      errorMessage = null;
      if (step == 1 && pin.length < 4) {
        pin += digit;
        if (pin.length == 4) {
          // Delay briefly to show the 4th filled circle before advancing to step 2
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                step = 2;
              });
            }
          });
        }
      } else if (step == 2 && confirmPin.length < 4) {
        confirmPin += digit;
        if (confirmPin.length == 4) {
          if (pin == confirmPin) {
            _savePin();
          } else {
            // Error! PIN mismatch.
            setState(() {
              errorMessage = "PINs do not match. Try again.";
              confirmPin = ''; // Reset confirm pin on error
            });
          }
        }
      }
    });
  }

  void _onBackspaceTap() {
    if (isProcessing) return;
    setState(() {
      errorMessage = null;
      if (step == 1 && pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      } else if (step == 2) {
        if (confirmPin.isNotEmpty) {
          confirmPin = confirmPin.substring(0, confirmPin.length - 1);
        } else {
          // Allow backspacing to step 1
          step = 1;
          pin = pin.substring(0, pin.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PinSetupView(
        step: step,
        pinLength: step == 1 ? pin.length : confirmPin.length,
        errorMessage: errorMessage,
        isProcessing: isProcessing,
        enableBiometric: enableBiometric,
        biometricAvailability: biometricAvailability,
        onBiometricChanged: (val) {
          setState(() {
            enableBiometric = val;
          });
        },
        onDigitTap: _onDigitTap,
        onBackspaceTap: _onBackspaceTap,
        onBackTap: () {
          if (step == 2) {
            setState(() {
              step = 1;
              confirmPin = '';
            });
          } else if (appRouter.canPop()) {
            appRouter.pop();
          }
        },
      ),
    );
  }
}
