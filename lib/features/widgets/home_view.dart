import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import '../models/vault_item.dart';
import 'home/search_bar_widget.dart';
import 'home/quick_actions_grid.dart';
import 'home/favorites_list.dart';
import 'home/stats_grid.dart';
import 'home/recent_activity_list.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  String _searchQuery = '';

  void _onCopyPassword(VaultItem item) {
    final value = item.isPassword
        ? (item.password ?? '')
        : (item.content ?? '');
    Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isPassword
              ? 'Password copied to clipboard'
              : 'Note copied to clipboard',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onToggleFavorite(VaultItem item) {
    ref.read(vaultProvider.notifier).toggleFavorite(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteItemsProvider);
    final recent = ref.watch(recentItemsProvider(5));

    final filteredFavorites = _searchQuery.isEmpty
        ? favorites
        : favorites.where((i) => i.matchesSearch(_searchQuery)).toList();
    final filteredRecent = _searchQuery.isEmpty
        ? recent
        : recent.where((i) => i.matchesSearch(_searchQuery)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            onChanged: (query) => setState(() => _searchQuery = query),
          ),
          const QuickActionsGrid(),
          FavoritesList(
            favorites: filteredFavorites,
            onCopy: _onCopyPassword,
            onToggleFavorite: _onToggleFavorite,
          ),
          const StatsGrid(),
          RecentActivityList(
            recentItems: filteredRecent,
            onCopy: _onCopyPassword,
          ),
        ],
      ),
    );
  }
}
