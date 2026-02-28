import 'package:flutter/material.dart';
import 'package:notes_vault/security/biometric_auth.dart';

/// Shows a retry/skip dialog when biometric authentication fails or is cancelled.
Future<bool?> showBiometricRetryDialog(BuildContext context, String message) {
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

/// Shows a dialog telling the user to enroll biometrics in device settings.
void showBiometricNotEnrolledDialog(
  BuildContext context, {
  required VoidCallback onCancel,
  required VoidCallback onOpenSettings,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Biometrics not set up"),
      content: const Text("Please enroll biometrics in your device settings."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            BiometricAuth.openBiometricSettings();
            onOpenSettings();
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
