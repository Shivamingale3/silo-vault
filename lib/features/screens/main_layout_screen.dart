import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/features/widgets/home/custom_bottom_nav.dart';
import 'package:notes_vault/features/widgets/shared/common_header.dart';

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
          // IconButton(
          //   icon: const Icon(Icons.tune),
          //   color: isDark ? Colors.white70 : Colors.black54,
          //   onPressed: () {},
          //   splashRadius: 20,
          // ),
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   color: isDark ? Colors.white70 : Colors.black54,
          //   onPressed: () {},
          //   splashRadius: 20,
          // ),
          // IconButton(
          //   icon: const Icon(Icons.lock),
          //   color: isDark ? Colors.white70 : Colors.black54,
          //   onPressed: () {},
          //   splashRadius: 20,
          // ),
        ];
        break;
      case 2:
        title = 'Generator';
        actions = [];
        break;
      case 3:
        title = 'Settings';
        actions = [
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.surfaceContainer,
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: Theme.of(
          //         context,
          //       ).colorScheme.onSurface.withValues(alpha: 0.05),
          //     ),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.lock,
          //       color: Theme.of(context).colorScheme.onSurface,
          //       size: 20,
          //     ),
          //     onPressed: () {},
          //     splashRadius: 20,
          //   ),
          // ),
        ];
        break;
      case 0:
      default:
        title = 'Notes Vault';
        actions = [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: () {
              context.push(AppRoutes.testScreen);
            },
            splashRadius: 20,
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white10 : Colors.black12,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              Icons.person_outline,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
          ),
        ];
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
        extendBody: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CommonHeader(title: title, leading: leading, actions: actions),
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
