import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import 'package:notes_vault/features/models/vault_item.dart';
import 'package:notes_vault/features/widgets/home/search_bar_widget.dart';
import 'vault/vault_filter_tabs.dart';
import 'vault/vault_item_tile.dart';

class VaultView extends ConsumerStatefulWidget {
  const VaultView({super.key});

  @override
  ConsumerState<VaultView> createState() => _VaultViewState();
}

class _VaultViewState extends ConsumerState<VaultView> {
  int _selectedFilterIndex = 0;
  String _searchQuery = '';
  final Set<ItemTag> _selectedTags = {};
  SortBy _sortBy = SortBy.dateUpdated;

  List<VaultItem> _applyFilters(List<VaultItem> items) {
    // Step 1: Apply search
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) => item.matchesSearch(_searchQuery)).toList();
    }

    // Step 2: Apply tag filter
    if (_selectedTags.isNotEmpty) {
      items = items.where((item) => item.hasAnyTag(_selectedTags)).toList();
    }

    // Step 3: Apply sort
    items = List<VaultItem>.from(items);
    switch (_sortBy) {
      case SortBy.nameAsc:
        items.sort((a, b) => a.title.compareTo(b.title));
      case SortBy.nameDesc:
        items.sort((a, b) => b.title.compareTo(a.title));
      case SortBy.dateUpdated:
        items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case SortBy.dateCreated:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortBy.category:
        items.sort((a, b) => a.category.name.compareTo(b.category.name));
    }

    return items;
  }

  void _onToggleFavorite(VaultItem item) {
    ref.read(vaultProvider.notifier).toggleFavorite(item.id);
  }

  void _onTrash(VaultItem item) {
    ref.read(vaultProvider.notifier).trashItem(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.title}" moved to Trash'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(vaultProvider.notifier).restoreItem(item.id);
          },
        ),
      ),
    );
  }

  void _onRestore(VaultItem item) {
    ref.read(vaultProvider.notifier).restoreItem(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.title}" restored'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _sortLabel(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.nameAsc:
        return 'Name (A-Z)';
      case SortBy.nameDesc:
        return 'Name (Z-A)';
      case SortBy.dateUpdated:
        return 'Last Updated';
      case SortBy.dateCreated:
        return 'Date Created';
      case SortBy.category:
        return 'Category';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Select the right provider based on filter tab
    List<VaultItem> baseItems;
    switch (_selectedFilterIndex) {
      case 1:
        baseItems = ref.watch(passwordItemsProvider);
      case 2:
        baseItems = ref.watch(noteItemsProvider);
      case 3:
        baseItems = ref.watch(favoriteItemsProvider);
      case 4:
        baseItems = ref.watch(trashedItemsProvider);
      default:
        baseItems = ref.watch(activeItemsProvider);
    }

    final filteredItems = _applyFilters(baseItems);

    // Collect all unique tags from current active items for chip row
    final allActiveTags = <ItemTag>{};
    for (final item in ref.watch(activeItemsProvider)) {
      allActiveTags.addAll(item.tags);
    }
    final sortedTags = allActiveTags.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VaultFilterTabs(
          selectedIndex: _selectedFilterIndex,
          onFilterChanged: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),
        SearchBarWidget(
          onChanged: (query) => setState(() => _searchQuery = query),
        ),

        // Tag chips row
        _buildTagChipsRow(isDark, colorScheme, sortedTags),

        // Sort & result count row
        _buildSortRow(isDark, colorScheme, filteredItems.length),

        // Items list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(vaultProvider.notifier).reload(),
            child: filteredItems.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [_buildEmptyState(isDark)],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return VaultItemTile(
                        item: item,
                        onToggleFavorite: () => _onToggleFavorite(item),
                        onTrash: () => _onTrash(item),
                        onRestore: () => _onRestore(item),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagChipsRow(
    bool isDark,
    ColorScheme colorScheme,
    List<ItemTag> allTags,
  ) {
    if (allTags.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: allTags.map((tag) {
          final isSelected = _selectedTags.contains(tag);
          final label = tag.name[0].toUpperCase() + tag.name.substring(1);

          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: FilterChip(
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: colorScheme.primary,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSortRow(bool isDark, ColorScheme colorScheme, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count items',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          PopupMenuButton<SortBy>(
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => SortBy.values.map((s) {
              return PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    if (s == _sortBy)
                      Icon(Icons.check, size: 16, color: colorScheme.primary)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(_sortLabel(s), style: const TextStyle(fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort, size: 16, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  _sortLabel(_sortBy),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your filters or search',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
