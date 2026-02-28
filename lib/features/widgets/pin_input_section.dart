import 'package:flutter/material.dart';
import 'package:notes_vault/features/widgets/pin_input.dart';

class PinInputSection extends StatelessWidget {
  final int step;
  final bool enabled;
  final bool obscurePin;
  final String? errorMessage;
  final Function(String) onPinComplete;

  const PinInputSection({
    super.key,
    required this.step,
    required this.enabled,
    required this.obscurePin,
    required this.onPinComplete,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
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
          onPinComplete: onPinComplete,
          obscurePin: obscurePin,
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
}
