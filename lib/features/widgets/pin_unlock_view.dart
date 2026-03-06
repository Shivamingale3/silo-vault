import 'package:flutter/material.dart';
import 'package:silo_vault/features/widgets/custom_num_pad.dart';
import 'package:silo_vault/features/widgets/pin_indicators.dart';

class PinUnlockView extends StatelessWidget {
  final String pin;
  final String? errorMessage;
  final bool isProcessing;
  final bool isBiometricEnabled;
  final Function(String) onDigitTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onBiometricTap;

  const PinUnlockView({
    super.key,
    required this.pin,
    this.errorMessage,
    required this.isProcessing,
    required this.isBiometricEnabled,
    required this.onDigitTap,
    required this.onBackspaceTap,
    required this.onBiometricTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmoled = theme.scaffoldBackgroundColor == Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 48), // Match top offset
        Text(
          "Unlock Silo Vault",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: isAmoled ? Colors.white : theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your 4-digit code",
          style: TextStyle(
            fontSize: 14,
            color: isAmoled
                ? Colors.grey[400]
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 48),

        Hero(
          tag: 'pin_indicators',
          child: PinIndicators(
            pinLength: pin.length,
            isError: errorMessage != null,
          ),
        ),

        const SizedBox(height: 16),

        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          const SizedBox(height: 18), // Placeholder to maintain height

        const Spacer(),

        CustomNumPad(onDigitTap: onDigitTap, onBackspaceTap: onBackspaceTap),

        const SizedBox(height: 32),

        if (isProcessing)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CircularProgressIndicator(),
          )
        else if (isBiometricEnabled)
          TextButton.icon(
            onPressed: onBiometricTap,
            icon: Icon(
              Icons.fingerprint,
              size: 28,
              color: isAmoled ? Colors.white : theme.colorScheme.primary,
            ),
            label: Text(
              "Use Biometric",
              style: TextStyle(
                color: isAmoled ? Colors.white : theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CircularProgressIndicator(),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
