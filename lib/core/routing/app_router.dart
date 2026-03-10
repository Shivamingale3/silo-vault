import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silo_vault/constants/app_routes.dart';
import 'package:silo_vault/features/screens/add_note_screen.dart';
import 'package:silo_vault/features/screens/app_lock_screen.dart';
import 'package:silo_vault/features/screens/error_screen.dart';
import 'package:silo_vault/features/screens/home_screen.dart';
import 'package:silo_vault/features/screens/test_screen.dart';
import 'package:silo_vault/features/screens/vault_screen.dart';
import 'package:silo_vault/features/screens/pin_setup_screen.dart';
import 'package:silo_vault/features/screens/splash_screen.dart';
import 'package:silo_vault/features/screens/main_layout_screen.dart';
import 'package:silo_vault/features/screens/view_note_screen.dart';
import 'package:silo_vault/features/screens/view_password_screen.dart';
import 'package:silo_vault/features/screens/add_password_screen.dart';
import 'package:silo_vault/features/screens/edit_note_screen.dart';
import 'package:silo_vault/features/screens/edit_password_screen.dart';
import 'package:silo_vault/features/screens/password_generator_screen.dart';
import 'package:silo_vault/features/screens/settings_screen.dart';
import 'package:silo_vault/features/screens/db_viewer_screen.dart';
import 'package:silo_vault/features/screens/update_screen.dart';
import 'package:silo_vault/features/models/vault_item.dart';
import 'package:silo_vault/core/enums/app_enums.dart';
import 'package:silo_vault/core/security/secure_storage.dart';

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
      path: AppRoutes.update,
      builder: (context, state) => const UpdateScreen(),
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
    GoRoute(
      path: AppRoutes.dbViewer,
      builder: (context, state) => const DbViewerScreen(),
    ),
    GoRoute(
      path: AppRoutes.passwordGenerator,
      builder: (context, state) => const PasswordGeneratorScreen(),
    ),
    GoRoute(
      path: AppRoutes.testScreen,
      builder: (context, state) => const TestScreen(),
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
              builder: (context, state) => const PasswordGeneratorScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    // Check for mandatory update
    final isUpdateAvailable = await SecureStorage.read(AppKeys.updateAvailable);
    if (isUpdateAvailable == 'true' && state.matchedLocation != AppRoutes.update) {
      return AppRoutes.update;
    }
    return null;
  },
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error);
  },
);
