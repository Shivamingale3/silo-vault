import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_routes.dart';
import '../../../core/enums/db_enums.dart';
import '../../models/vault_item.dart';

class VaultItemTile extends StatefulWidget {
  final VaultItem item;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTrash;
  final VoidCallback? onRestore;

  const VaultItemTile({
    super.key,
    required this.item,
    this.onToggleFavorite,
    this.onTrash,
    this.onRestore,
  });

  @override
  State<VaultItemTile> createState() => _VaultItemTileState();
}

class _VaultItemTileState extends State<VaultItemTile> {
  bool _passwordVisible = false;

  VaultItem get item => widget.item;

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getCategoryColor(NoteCategory category) {
    switch (category) {
      case NoteCategory.personal:
        return Colors.blue;
      case NoteCategory.work:
        return Colors.orange;
      case NoteCategory.finance:
        return Colors.green;
      case NoteCategory.social:
        return Colors.purple;
      case NoteCategory.development:
        return Colors.teal;
      case NoteCategory.entertainment:
        return Colors.pink;
      case NoteCategory.travel:
        return Colors.indigo;
      case NoteCategory.health:
        return Colors.red;
    }
  }

  void _showContextMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (item.isPassword) ...[
                  _buildMenuOption(
                    icon: Icons.person_outline,
                    label: 'Copy Username',
                    onTap: () {
                      Navigator.pop(ctx);
                      _copyToClipboard(item.username ?? '', 'Username');
                    },
                  ),
                  _buildMenuOption(
                    icon: Icons.key_outlined,
                    label: 'Copy Password',
                    onTap: () {
                      Navigator.pop(ctx);
                      _copyToClipboard(item.password ?? '', 'Password');
                    },
                  ),
                ] else ...[
                  _buildMenuOption(
                    icon: Icons.content_copy_outlined,
                    label: 'Copy Note',
                    onTap: () {
                      Navigator.pop(ctx);
                      _copyToClipboard(item.content ?? '', 'Note');
                    },
                  ),
                ],
                _buildMenuOption(
                  icon: item.isFavorite ? Icons.star : Icons.star_border,
                  label: item.isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.onToggleFavorite?.call();
                  },
                ),
                if (item.isTrashed)
                  _buildMenuOption(
                    icon: Icons.restore,
                    label: 'Restore from Trash',
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.onRestore?.call();
                    },
                  )
                else
                  _buildMenuOption(
                    icon: Icons.delete_outline,
                    label: 'Move to Trash',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.onTrash?.call();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(item.category);

    final iconData = item.isPassword ? Icons.password : Icons.description;
    final iconColor = item.isPassword
        ? colorScheme.primary
        : Colors.amber.shade500;
    final iconBgColor = iconColor.withValues(alpha: 0.1);

    return Opacity(
      opacity: item.isTrashed ? 0.5 : 1.0,
      child: InkWell(
        onTap: () {
          if (item.isPassword) {
            context.push(AppRoutes.viewPassword, extra: item);
          } else {
            context.push(AppRoutes.viewNote, extra: item);
          }
        },
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.isFavorite) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.isPassword
                              ? (_passwordVisible
                                    ? (item.password ?? '')
                                    : (item.username ?? ''))
                              : item.displaySubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: (item.isPassword && _passwordVisible)
                                ? 'monospace'
                                : null,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.isPassword) ...[
                        GestureDetector(
                          onTap: () {
                            setState(
                              () => _passwordVisible = !_passwordVisible,
                            );
                          },
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: isDark ? Colors.white54 : Colors.black54,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () =>
                              _copyToClipboard(item.password ?? '', 'Password'),
                          child: Icon(
                            Icons.content_copy,
                            color: isDark ? Colors.white54 : Colors.black54,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ] else ...[
                        GestureDetector(
                          onTap: () =>
                              _copyToClipboard(item.content ?? '', 'Note'),
                          child: Icon(
                            Icons.content_copy,
                            color: isDark ? Colors.white54 : Colors.black54,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.white38 : Colors.black38,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              // Category & tags row
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _buildChip(
                    label:
                        item.category.name[0].toUpperCase() +
                        item.category.name.substring(1),
                    color: categoryColor,
                    isDark: isDark,
                  ),
                  ...item.tags.map(
                    (tag) => _buildChip(
                      label: tag.name[0].toUpperCase() + tag.name.substring(1),
                      color: isDark ? Colors.white38 : Colors.black38,
                      isDark: isDark,
                    ),
                  ),
                  if (item.isPassword && item.passwordStrength != null)
                    _buildStrengthChip(item.passwordStrength!, isDark),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStrengthChip(PasswordStrength strength, bool isDark) {
    late final String label;
    late final Color color;

    switch (strength) {
      case PasswordStrength.weak:
        label = 'Weak';
        color = Colors.red;
      case PasswordStrength.fair:
        label = 'Fair';
        color = Colors.orange;
      case PasswordStrength.strong:
        label = 'Strong';
        color = Colors.blue;
      case PasswordStrength.veryStrong:
        label = 'Very Strong';
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
