import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_routes.dart';

class VaultItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final bool isStarred;
  final bool showVisibility;
  final bool showCopy;
  final double opacity;
  final String type; // Added type field for dynamic navigation

  const VaultItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
    this.isStarred = false,
    this.showVisibility = false,
    this.showCopy = false,
    this.opacity = 1.0,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: () {
          if (type == 'Password') {
            context.push(AppRoutes.viewPassword);
          } else {
            context.push(AppRoutes.viewNote);
          }
        },
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
          child: Row(
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
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isStarred) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showVisibility) ...[
                    Icon(
                      Icons.visibility,
                      color: isDark ? Colors.white54 : Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (showCopy) ...[
                    Icon(
                      Icons.content_copy,
                      color: isDark ? Colors.white54 : Colors.black54,
                      size: 20,
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
        ),
      ),
    );
  }
}
