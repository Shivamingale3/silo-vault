import 'package:flutter/material.dart';
import 'home/home_header.dart';
import 'home/search_bar_widget.dart';
import 'home/quick_actions_grid.dart';
import 'home/favorites_list.dart';
import 'home/stats_grid.dart';
import 'home/recent_activity_list.dart';
import 'home/custom_bottom_nav.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onAddNoteTap;

  const HomeView({super.key, required this.onAddNoteTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 100,
          ), // Space for bottom nav + FAB
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SearchBarWidget(),
              QuickActionsGrid(),
              FavoritesList(),
              StatsGrid(),
              RecentActivityList(),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0), // Above the nav bar
        child: FloatingActionButton(
          onPressed: onAddNoteTap,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
