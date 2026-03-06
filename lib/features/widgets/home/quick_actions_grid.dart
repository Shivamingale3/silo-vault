import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(
            context,
            icon: Icons.password,
            label: 'Add Password',
            onTap: () {
              context.push(AppRoutes.addPassword);
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.edit_note,
            label: 'Add Note',
            onTap: () {
              context.push(AppRoutes.addNote);
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.vpn_key,
            label: 'Generator',
            onTap: () {
              context.go('/generator');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
