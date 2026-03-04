import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? icon;

  const PillChip({
    super.key,
    required this.label,
    this.isActive = false,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    final borderColor = isActive
        ? primaryColor
        : (isDark ? Colors.white12 : Colors.black12);
    final backgroundColor = isActive
        ? primaryColor.withValues(alpha: 0.1)
        : Colors.transparent;
    final textColor = isActive
        ? primaryColor
        : (isDark ? Colors.white54 : Colors.black54);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 4)],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
