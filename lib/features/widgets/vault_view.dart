import 'package:flutter/material.dart';
import 'package:notes_vault/features/widgets/home/search_bar_widget.dart';
import 'vault/vault_filter_tabs.dart';
import 'vault/vault_item_tile.dart';

class VaultView extends StatelessWidget {
  const VaultView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 120, // Space for bottom nav + FAB
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VaultFilterTabs(),
          const SearchBarWidget(),
          const SizedBox(height: 8),
          VaultItemTile(
            type: 'Password',
            title: 'Adobe Creative Cloud',
            subtitle: 'design@studio.com',
            iconData: Icons.password,
            iconColor: colorScheme.primary,
            iconBgColor: colorScheme.primary.withValues(alpha: 0.1),
            showVisibility: true,
            showCopy: true,
          ),
          VaultItemTile(
            type: 'Note',
            title: 'Grocery List',
            subtitle: 'Milk, Eggs, Bread...',
            iconData: Icons.description,
            iconColor: Colors.amber.shade500,
            iconBgColor: Colors.amber.shade500.withValues(alpha: 0.1),
            isStarred: true,
          ),
          VaultItemTile(
            type: 'Password',
            title: 'GitHub',
            subtitle: 'dev_user',
            iconData: Icons.password,
            iconColor: colorScheme.primary,
            iconBgColor: colorScheme.primary.withValues(alpha: 0.1),
            showVisibility: true,
            showCopy: true,
          ),
          VaultItemTile(
            type: 'Password',
            title: 'Steam Account',
            subtitle: 'gamer_pro_99',
            iconData: Icons.key,
            iconColor: isDark ? Colors.white54 : Colors.black54,
            iconBgColor: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            opacity: 0.5,
          ),
        ],
      ),
    );
  }
}
