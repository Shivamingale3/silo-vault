import 'package:flutter/material.dart';
import 'package:notes_vault/core/enums/security_enums.dart';

class BiometricOption extends StatelessWidget {
  final bool enableBiometric;
  final bool isProcessing;
  final BiometricAvailability biometricAvailability;
  final ValueChanged<bool> onChanged;

  const BiometricOption({
    super.key,
    required this.enableBiometric,
    required this.isProcessing,
    required this.biometricAvailability,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (biometricAvailability != BiometricAvailability.notEnrolled &&
        biometricAvailability != BiometricAvailability.available) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: enableBiometric,
          onChanged: isProcessing ? null : (val) => onChanged(val ?? false),
        ),
        const Text("Enable Biometric"),
      ],
    );
  }
}
