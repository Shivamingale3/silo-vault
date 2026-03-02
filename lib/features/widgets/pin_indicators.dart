import 'package:flutter/material.dart';

class PinIndicators extends StatelessWidget {
  final int pinLength;
  final int maxLength;
  final bool isError;
  final bool animate;

  const PinIndicators({
    super.key,
    required this.pinLength,
    this.maxLength = 4,
    this.isError = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < pinLength;

        return AnimatedContainer(
          duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
          margin: EdgeInsets.only(
            left: index == 0 ? 0 : 12,
            right: index == maxLength - 1 ? 0 : 12,
          ),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (isError ? Colors.red : Theme.of(context).colorScheme.primary)
                : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? Colors.transparent
                  : (isError
                        ? Colors.red
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3)),
              width: 2,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color:
                          (isError
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.primary)
                              .withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
