import 'package:flutter/material.dart';

class VaultFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  static const List<String> tabs = [
    'All',
    'Passwords',
    'Notes',
    'Favorites',
    'Trash',
  ];

  const VaultFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => onFilterChanged(index),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
