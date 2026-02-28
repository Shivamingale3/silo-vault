import 'package:flutter/material.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/security_enums.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/features/widgets/pin_input.dart';
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

  Future<BiometricSetupResult> _attemptBiometricSetup() async {
    final result = await BiometricAuth.authenticate();

    if (!mounted) return BiometricSetupResult.skipped;

    switch (result) {
      case BiometricResult.success:
        await SecureStorage.setBiometricStatus(true);
        return BiometricSetupResult.success;

      case BiometricResult.cancelled:
      case BiometricResult.failed:
        // Show retry/skip dialog and wait for user's choice
        final shouldRetry = await _showBiometricRetryDialog(
          result == BiometricResult.cancelled
              ? "Biometric authentication was cancelled."
              : "Biometric authentication failed.",
        );

        if (shouldRetry == true) {
          return _attemptBiometricSetup(); // Retry
        } else {
          await SecureStorage.setBiometricStatus(false);
          return BiometricSetupResult.skipped;
        }
    }
  }

  Future<bool?> _showBiometricRetryDialog(String message) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Biometric Setup"),
        content: Text(
          "$message\n\nWould you like to try again or skip biometric setup?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Skip"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
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
      // Handle biometric setup
      if (enableBiometric) {
        if (biometricAvailability == BiometricAvailability.notEnrolled) {
          if (!mounted) return;
          _showBiometricNotEnrolledDialog();
          return; // Stop here — user must enroll biometrics first
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

      // Save the PIN
      await SecureStorage.setAppPin(pin);

      if (!mounted) return;
      appRouter.replace(AppRoutes.appLock);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
        enabled = true;
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text("Error setting PIN: ${e.toString()}"),
          action: SnackBarAction(label: "Retry", onPressed: _savePin),
        ),
      );
    }
  }

  void _showBiometricNotEnrolledDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Biometrics not set up"),
        content: const Text(
          "Please enroll biometrics in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset processing state so user can try again
              setState(() {
                isProcessing = false;
                enabled = true;
              });
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BiometricAuth.openBiometricSettings();
              // Reset processing state so user can retry after enrolling
              setState(() {
                isProcessing = false;
                enabled = true;
              });
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Widget buildPinInput() {
    return Column(
      children: [
        Text(
          step == 1 ? "Enter your PIN" : "Confirm your PIN",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        PinInput(
          key: ValueKey(step),
          enabled: enabled,
          onPinComplete: (value) {
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
                _savePin(); // Called OUTSIDE setState
              } else {
                setState(() {
                  errorMessage = "PINs do not match";
                });
              }
            }
          },
          obscurePin: hidePin,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
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
            buildPinInput(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () {
                          setState(() {
                            hidePin = !hidePin;
                          });
                        },
                  label: Text(hidePin ? "Show PIN" : "Hide"),
                  icon: Icon(hidePin ? Icons.visibility : Icons.visibility_off),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (step == 2) const SizedBox(width: 20),
                if (step == 2)
                  ElevatedButton.icon(
                    onPressed: isProcessing ? null : resetPinSetup,
                    label: const Text("Reset"),
                    icon: const Icon(Icons.refresh),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
            if (biometricAvailability == BiometricAvailability.notEnrolled ||
                biometricAvailability == BiometricAvailability.available)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: enableBiometric,
                    onChanged: isProcessing
                        ? null
                        : (val) {
                            setState(() {
                              enableBiometric = val ?? false;
                            });
                          },
                  ),
                  const Text("Enable Biometric"),
                ],
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
