import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/features/screens/add_note_screen.dart';
import 'package:notes_vault/features/screens/app_lock_screen.dart';
import 'package:notes_vault/features/screens/error_screen.dart';
import 'package:notes_vault/features/screens/home_screen.dart';
import 'package:notes_vault/features/screens/vault_screen.dart';
import 'package:notes_vault/features/screens/pin_setup_screen.dart';
import 'package:notes_vault/features/screens/splash_screen.dart';

final appRouter = GoRouter(
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
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.vault,
      builder: (context, state) => const VaultScreen(),
    ),
    GoRoute(
      path: AppRoutes.addNote,
      builder: (context, state) => const AddNoteScreen(),
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error);
  },
);
