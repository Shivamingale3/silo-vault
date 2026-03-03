import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNav({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 32.0,
        left: 8.0,
        right: 8.0,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home_filled,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTap?.call(0),
            ),
            _buildNavItem(
              context,
              icon: Icons.dataset_outlined,
              label: 'Vault',
              isActive: currentIndex == 1,
              onTap: () => onTap?.call(1),
            ),
            _buildNavItem(
              context,
              icon: Icons.search,
              label: 'Search',
              isActive: currentIndex == 2,
              onTap: () => onTap?.call(2),
            ),
            _buildNavItem(
              context,
              icon: Icons.token_outlined,
              label: 'Generator',
              isActive: currentIndex == 3,
              onTap: () => onTap?.call(3),
            ),
            _buildNavItem(
              context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              isActive: currentIndex == 4,
              onTap: () => onTap?.call(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isActive
        ? colorScheme.primary
        : (isDark ? Colors.white54 : Colors.black54);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
