import 'package:flutter/material.dart';

class SecurityLockoutView extends StatelessWidget {
  final String remainingTime;
  final VoidCallback onRequestEmergencyRecovery;
  final VoidCallback onContactSupport;

  const SecurityLockoutView({
    super.key,
    required this.remainingTime,
    required this.onRequestEmergencyRecovery,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmoled = theme.scaffoldBackgroundColor == Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top App Bar Area (Mockup specific)
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shield,
                    color: isAmoled
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "VAULT APP",
                    style: TextStyle(
                      color: isAmoled
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // Lock Icon Container
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isAmoled ? Colors.black : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAmoled
                  ? Colors.white.withValues(alpha: 0.1)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: isAmoled
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Center(
            child: Icon(
              Icons.lock,
              size: 48,
              color: isAmoled ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Headings
        Text(
          "SECURITY LOCKOUT",
          style: TextStyle(
            color: theme.colorScheme.primary, // Blueish
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Access Denied",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "Too many failed attempts. For your\nsecurity, the vault has been temporarily\nlocked.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: isAmoled
                ? Colors.grey[400]
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),

        const SizedBox(height: 32),

        // Timer Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isAmoled
                ? const Color(0xFF0A0A0E)
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isAmoled
                  ? Colors.white.withValues(alpha: 0.05)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Text(
                "AVAILABLE IN",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isAmoled
                      ? Colors.grey[500]
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                remainingTime,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),
      ],
    );
  }
}
