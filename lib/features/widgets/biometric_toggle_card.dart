import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoSwitch
import 'package:notes_vault/core/enums/security_enums.dart';

class BiometricToggleCard extends StatelessWidget {
  final bool enableBiometric;
  final bool isProcessing;
  final BiometricAvailability biometricAvailability;
  final ValueChanged<bool> onChanged;

  const BiometricToggleCard({
    super.key,
    required this.enableBiometric,
    required this.isProcessing,
    required this.biometricAvailability,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (biometricAvailability == BiometricAvailability.unavailable) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isAmoled = theme.scaffoldBackgroundColor == Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isAmoled
            ? const Color(0xFF121212)
            : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAmoled
              ? Colors.white.withValues(alpha: 0.1)
              : theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAmoled
                      ? Colors.white.withValues(alpha: 0.1)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.fingerprint,
                  color: isAmoled ? Colors.white : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Biometric Unlock",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isAmoled
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Use FaceID or TouchID",
                    style: TextStyle(
                      fontSize: 12,
                      color: isAmoled
                          ? Colors.grey[400]
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          CupertinoSwitch(
            value: enableBiometric,
            onChanged: isProcessing ? null : onChanged,
            activeTrackColor: isAmoled
                ? Colors.white
                : theme.colorScheme.primary,
            inactiveTrackColor: isAmoled
                ? Colors.grey[800]
                : theme.colorScheme.surfaceContainerHighest,
            thumbColor: isAmoled && enableBiometric
                ? Colors.black
                : Colors.white,
          ),
        ],
      ),
    );
  }
}
