import 'package:flutter/material.dart';

class FavoriteItem {
  final String title;
  final String subtitle;
  final String password;
  final bool isStarred;

  const FavoriteItem({
    required this.title,
    required this.subtitle,
    required this.password,
    this.isStarred = true,
  });
}

class RecentActivityItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String timeAgo;
  final String type;

  const RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timeAgo,
    required this.type,
  });
}

class HomeSampleData {
  static const List<FavoriteItem> favorites = [
    FavoriteItem(
      title: 'Primary Email',
      subtitle: 'user@outlook.com',
      password: '••••••••',
    ),
    FavoriteItem(
      title: 'Work Server',
      subtitle: '192.168.1.104',
      password: '••••••••',
    ),
  ];

  static const List<RecentActivityItem> recentActivities = [
    RecentActivityItem(
      title: 'Netflix',
      subtitle: 'Password • 1h ago',
      icon: Icons.lock_outline,
      timeAgo: '1h ago',
      type: 'Password',
    ),
    RecentActivityItem(
      title: 'Meeting Notes',
      subtitle: 'Note • 3h ago',
      icon: Icons.description_outlined,
      timeAgo: '3h ago',
      type: 'Note',
    ),
  ];
}
