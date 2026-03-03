import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/vault_item.dart';
import '../models/sample_data.dart';
import 'home/search_bar_widget.dart';
import 'home/quick_actions_grid.dart';
import 'home/favorites_list.dart';
import 'home/stats_grid.dart';
import 'home/recent_activity_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _searchQuery = '';

  List<VaultItem> get _filteredFavorites {
    return SampleData.favoriteItems
        .where((item) => item.matchesSearch(_searchQuery))
        .toList();
  }

  List<VaultItem> get _filteredRecent {
    final recent = SampleData.recentItems(count: 5);
    if (_searchQuery.isEmpty) return recent;
    return recent.where((item) => item.matchesSearch(_searchQuery)).toList();
  }

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
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            favorites: _filteredFavorites,
            onCopy: _onCopyPassword,
            onToggleFavorite: _onToggleFavorite,
          ),
          const StatsGrid(),
          RecentActivityList(
            recentItems: _filteredRecent,
            onCopy: _onCopyPassword,
          ),
        ],
      ),
    );
  }
}
