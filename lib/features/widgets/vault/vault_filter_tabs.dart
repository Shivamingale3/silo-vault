import 'package:flutter/material.dart';

class VaultFilterTabs extends StatefulWidget {
  const VaultFilterTabs({super.key});

  @override
  State<VaultFilterTabs> createState() => _VaultFilterTabsState();
}

class _VaultFilterTabsState extends State<VaultFilterTabs> {
  int _selectedIndex = 0;
  final List<String> _tabs = [
    'All',
    'Passwords',
    'Notes',
    'Favorites',
    'Trash',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == _selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
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
                  _tabs[index],
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
