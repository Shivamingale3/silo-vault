import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/features/screens/add_note_screen.dart';
import 'package:notes_vault/features/screens/app_lock_screen.dart';
import 'package:notes_vault/features/screens/error_screen.dart';
import 'package:notes_vault/features/screens/home_screen.dart';
import 'package:notes_vault/features/screens/vault_screen.dart';
import 'package:notes_vault/features/screens/pin_setup_screen.dart';
import 'package:notes_vault/features/screens/splash_screen.dart';
import 'package:notes_vault/features/screens/main_layout_screen.dart';
import 'package:notes_vault/features/screens/view_note_screen.dart';
import 'package:notes_vault/features/screens/view_password_screen.dart';
import 'package:notes_vault/features/screens/add_password_screen.dart';
import 'package:notes_vault/features/screens/edit_note_screen.dart';
import 'package:notes_vault/features/screens/edit_password_screen.dart';
import 'package:notes_vault/features/models/vault_item.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.pinSetup,
      builder: (context, state) => const PinSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.appLock,
      builder: (context, state) => const AppLockScreen(),
    ),
    GoRoute(
      path: AppRoutes.addNote,
      builder: (context, state) => const AddNoteScreen(),
    ),
    GoRoute(
      path: AppRoutes.viewNote,
      builder: (context, state) =>
          ViewNoteScreen(item: state.extra as VaultItem),
    ),
    GoRoute(
      path: AppRoutes.viewPassword,
      builder: (context, state) =>
          ViewPasswordScreen(item: state.extra as VaultItem),
    ),
    GoRoute(
      path: AppRoutes.addPassword,
      builder: (context, state) => const AddPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.editNote,
      builder: (context, state) =>
          EditNoteScreen(item: state.extra as VaultItem),
    ),
    GoRoute(
      path: AppRoutes.editPassword,
      builder: (context, state) =>
          EditPasswordScreen(item: state.extra as VaultItem),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayoutScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vault,
              builder: (context, state) => const VaultScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/generator',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Generator'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Settings'))),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error);
  },
);
