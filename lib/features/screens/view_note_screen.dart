import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/features/models/vault_item.dart';

class ViewNoteScreen extends StatelessWidget {
  final VaultItem item;

  const ViewNoteScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: isDark
            ? theme.scaffoldBackgroundColor.withValues(alpha: 0.8)
            : theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 20,
        ),
        title: Text(
          item.title.length > 20
              ? '${item.title.substring(0, 20)}...'
              : item.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 24),
            onPressed: () {},
            splashRadius: 20,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last updated: ${item.timeAgoUpdated}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.category.name[0].toUpperCase() +
                        item.category.name.substring(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item.content ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note copied to clipboard'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: isDark ? Colors.white10 : Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.content_copy, size: 16),
                  label: const Text(
                    'Copy All',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.content ?? '',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 48),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags.map((tag) {
                    final label =
                        tag.name[0].toUpperCase() + tag.name.substring(1);
                    return _buildTagChip(context, label, _tagColor(tag));
                  }).toList(),
                ),
              ],
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Color _tagColor(ItemTag tag) {
    switch (tag) {
      case ItemTag.urgent:
        return Colors.red;
      case ItemTag.important:
        return Colors.orange;
      case ItemTag.archived:
        return Colors.grey;
      case ItemTag.shared:
        return Colors.blue;
      case ItemTag.encrypted:
        return Colors.green;
      case ItemTag.temporary:
        return Colors.amber;
      case ItemTag.pinned:
        return Colors.purple;
    }
  }

  Widget _buildTagChip(BuildContext context, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
