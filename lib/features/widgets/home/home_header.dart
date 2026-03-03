import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const HomeHeader({
    super.key,
    this.title = 'Notes Vault',
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              leading ??
                  Icon(Icons.shield, color: colorScheme.primary, size: 28),
              if (leading == null) const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children:
                actions ??
                [
                  IconButton(
                    icon: const Icon(Icons.lock_outline),
                    color: isDark ? Colors.white70 : Colors.black54,
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.white10 : Colors.black12,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 20,
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
