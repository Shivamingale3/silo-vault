import 'package:flutter/material.dart';

class PinActionButtons extends StatelessWidget {
  final bool isProcessing;
  final bool hidePin;
  final int step;
  final VoidCallback onToggleVisibility;
  final VoidCallback onReset;

  const PinActionButtons({
    super.key,
    required this.isProcessing,
    required this.hidePin,
    required this.step,
    required this.onToggleVisibility,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: isProcessing ? null : onToggleVisibility,
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
            onPressed: isProcessing ? null : onReset,
            label: const Text("Reset"),
            icon: const Icon(Icons.refresh),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      ],
    );
  }
}
