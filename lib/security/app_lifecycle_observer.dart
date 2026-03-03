import 'package:flutter/widgets.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/security/secure_storage.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  /// Routes where going to background should NOT trigger a lock.
  static const _exemptRoutes = {
    AppRoutes.splash,
    AppRoutes.pinSetup,
    AppRoutes.appLock,
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _backgroundedAt = DateTime.now();
        break;

      case AppLifecycleState.resumed:
        _onResumed();
        break;

      default:
        break;
    }
  }

  Future<void> _onResumed() async {
    final pausedAt = _backgroundedAt;
    _backgroundedAt = null;

    if (pausedAt == null) return;

    // Don't lock if already on an exempt screen (splash, pin setup, lock)
    final currentLocation =
        appRouter.routerDelegate.currentConfiguration.last.matchedLocation;
    if (_exemptRoutes.contains(currentLocation)) return;

    final timeoutSeconds = await SecureStorage.getAutoLockTimeout();
    final elapsed = DateTime.now().difference(pausedAt).inSeconds;

    if (elapsed >= timeoutSeconds) {
      appRouter.push(AppRoutes.appLock);
    }
  }
}
