import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/features/widgets/home/home_header.dart';
import 'package:notes_vault/features/widgets/home/custom_bottom_nav.dart';

class MainLayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = navigationShell.currentIndex;

    String title;
    List<Widget>? actions;
    Widget? leading;

    switch (currentIndex) {
      case 1:
        title = 'Notes Vault';
        actions = [
          IconButton(
            icon: const Icon(Icons.tune),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: () {},
            splashRadius: 20,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: () {},
            splashRadius: 20,
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: () {},
            splashRadius: 20,
          ),
        ];
        break;
      case 2:
        title = 'Generator';
        break;
      case 3:
        title = 'Settings';
        break;
      case 0:
      default:
        title = 'Notes Vault';
        break;
    }

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && currentIndex != 0) {
          navigationShell.goBranch(0, initialLocation: true);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HomeHeader(title: title, leading: leading, actions: actions),
              Expanded(child: navigationShell),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
