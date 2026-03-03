import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_routes.dart';
import '../../models/vault_item.dart';

class RecentActivityList extends StatelessWidget {
  final List<VaultItem> recentItems;
  final ValueChanged<VaultItem> onCopy;

  const RecentActivityList({
    super.key,
    required this.recentItems,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (recentItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black54,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'History',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: recentItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == recentItems.length - 1;

                return _buildActivityItem(
                  context,
                  item,
                  index: index,
                  isLast: isLast,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    VaultItem item, {
    required int index,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final icon = item.isPassword
        ? Icons.lock_outline
        : Icons.description_outlined;
    final typeLabel = item.isPassword ? 'Password' : 'Note';

    return InkWell(
      onTap: () {
        if (item.isPassword) {
          context.push(AppRoutes.viewPassword);
        } else {
          context.push(AppRoutes.viewNote);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(isLast ? 0 : 16).copyWith(
            topLeft: index == 0 ? const Radius.circular(16) : Radius.zero,
            topRight: index == 0 ? const Radius.circular(16) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
          ),
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$typeLabel • ${item.timeAgoUpdated}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onCopy(item),
              child: Icon(
                Icons.content_copy_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
