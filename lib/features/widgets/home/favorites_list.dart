import 'package:flutter/material.dart';
import '../../models/vault_item.dart';

class FavoritesList extends StatefulWidget {
  final List<VaultItem> favorites;
  final ValueChanged<VaultItem> onCopy;
  final ValueChanged<VaultItem> onToggleFavorite;

  const FavoritesList({
    super.key,
    required this.favorites,
    required this.onCopy,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  /// Tracks which favorite card's password is currently revealed.
  final Set<String> _revealedIds = {};

  void _toggleReveal(String id) {
    setState(() {
      if (_revealedIds.contains(id)) {
        _revealedIds.remove(id);
      } else {
        _revealedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'FAVORITES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            scrollDirection: Axis.horizontal,
            itemCount: widget.favorites.length,
            itemBuilder: (context, index) {
              return _buildFavoriteCard(context, widget.favorites[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(BuildContext context, VaultItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRevealed = _revealedIds.contains(item.id);

    // For passwords show masked/revealed, for notes show content preview.
    final displayValue = item.isPassword
        ? (isRevealed ? (item.password ?? '') : '••••••••')
        : (item.displaySubtitle);

    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.displaySubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onToggleFavorite(item),
                child: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  size: 18,
                  color: item.isFavorite
                      ? Colors.amber
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      fontFamily: item.isPassword ? 'monospace' : null,
                      fontSize: 14,
                      letterSpacing: item.isPassword ? 2 : 0,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isPassword)
                      GestureDetector(
                        onTap: () => _toggleReveal(item.id),
                        child: Icon(
                          isRevealed
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => widget.onCopy(item),
                      child: Icon(
                        Icons.content_copy_outlined,
                        size: 18,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
