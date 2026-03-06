import 'package:flutter/material.dart';
import 'package:silo_vault/core/enums/security_enums.dart';
import 'package:silo_vault/features/widgets/biometric_toggle_card.dart';
import 'package:silo_vault/features/widgets/custom_num_pad.dart';
import 'package:silo_vault/features/widgets/pin_indicators.dart';

class PinSetupView extends StatelessWidget {
  final int step;
  final int pinLength;
  final String? errorMessage;
  final bool isProcessing;
  final bool enableBiometric;
  final BiometricAvailability biometricAvailability;
  final ValueChanged<bool> onBiometricChanged;
  final Function(String) onDigitTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onBackTap;

  const PinSetupView({
    super.key,
    required this.step,
    required this.pinLength,
    this.errorMessage,
    required this.isProcessing,
    required this.enableBiometric,
    required this.biometricAvailability,
    required this.onBiometricChanged,
    required this.onDigitTap,
    required this.onBackspaceTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmoled = theme.scaffoldBackgroundColor == Colors.black;

    return Stack(
      children: [
        // Background Blurs imitating the HTML design
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(
                alpha: isAmoled ? 0.15 : 0.08,
              ),
            ),
            child: BackdropFilter(
              filter: const ColorFilter.mode(
                Colors.transparent,
                BlendMode.srcOver,
              ),
              child: Container(),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: -80,
          child: Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade900.withValues(
                alpha: isAmoled ? 0.2 : 0.1,
              ),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              // Top App Bar
              if (step == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: onBackTap,
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      // Title & Subtitle
                      Text(
                        step == 1 ? "Create your PIN" : "Confirm your PIN",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          color: isAmoled
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter a 4-digit code to secure your vault",
                        style: TextStyle(
                          fontSize: 14,
                          color: isAmoled
                              ? Colors.grey[400]
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      // PIN Indicators
                      Hero(
                        tag: 'pin_indicators',
                        child: PinIndicators(
                          pinLength: pinLength,
                          isError: errorMessage != null,
                        ),
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      const Spacer(),

                      // Biometric Toggle (Only shown on Step 1 per design)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: BiometricToggleCard(
                          enableBiometric: enableBiometric,
                          isProcessing: isProcessing,
                          biometricAvailability: biometricAvailability,
                          onChanged: onBiometricChanged,
                        ),
                      ),

                      // Num Pad
                      CustomNumPad(
                        onDigitTap: onDigitTap,
                        onBackspaceTap: onBackspaceTap,
                      ),

                      const SizedBox(height: 32),

                      if (isProcessing) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
