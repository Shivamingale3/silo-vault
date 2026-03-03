import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/features/widgets/home/home_header.dart';
import 'package:notes_vault/features/widgets/home/search_bar_widget.dart';
import 'package:notes_vault/features/widgets/home/custom_bottom_nav.dart';
import 'vault/vault_filter_tabs.dart';
import 'vault/vault_item_tile.dart';

class VaultView extends StatelessWidget {
  const VaultView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 120, // Space for bottom nav + FAB
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                title: 'Vault',
                leading: const SizedBox.shrink(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.tune),
                    color: isDark ? Colors.white70 : Colors.black54,
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    color: isDark ? Colors.white70 : Colors.black54,
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.lock),
                    color: isDark ? Colors.white70 : Colors.black54,
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                ],
              ),
              const VaultFilterTabs(),
              const SearchBarWidget(),
              const SizedBox(height: 8),
              VaultItemTile(
                title: 'Adobe Creative Cloud',
                subtitle: 'design@studio.com',
                iconData: Icons.password,
                iconColor: colorScheme.primary,
                iconBgColor: colorScheme.primary.withValues(alpha: 0.1),
                showVisibility: true,
                showCopy: true,
              ),
              VaultItemTile(
                title: 'Grocery List',
                subtitle: 'Milk, Eggs, Bread...',
                iconData: Icons.description,
                iconColor: Colors.amber.shade500,
                iconBgColor: Colors.amber.shade500.withValues(alpha: 0.1),
                isStarred: true,
              ),
              VaultItemTile(
                title: 'GitHub',
                subtitle: 'dev_user',
                iconData: Icons.password,
                iconColor: colorScheme.primary,
                iconBgColor: colorScheme.primary.withValues(alpha: 0.1),
                showVisibility: true,
                showCopy: true,
              ),
              VaultItemTile(
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
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: FloatingActionButton(
          onPressed: () {
            context.go(AppRoutes.addNote);
          },
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
