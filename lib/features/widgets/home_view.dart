import 'package:flutter/material.dart';
import 'home/search_bar_widget.dart';
import 'home/quick_actions_grid.dart';
import 'home/favorites_list.dart';
import 'home/stats_grid.dart';
import 'home/recent_activity_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 100, // Space for bottom nav + FAB
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SearchBarWidget(),
          QuickActionsGrid(),
          FavoritesList(),
          StatsGrid(),
          RecentActivityList(),
        ],
      ),
    );
  }
}
