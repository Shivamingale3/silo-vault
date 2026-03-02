import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/routing/app_router.dart';
import 'package:notes_vault/core/theme/app_theme.dart';
import 'package:notes_vault/core/theme/theme_provider.dart';
import 'package:notes_vault/database/isar.dart';
import 'package:notes_vault/security/app_lifecycle_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDb.init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    ThemeData getThemeData() {
      switch (themeMode) {
        case AppThemeMode.light:
          return AppTheme.lightTheme();
        case AppThemeMode.dark:
          return AppTheme.darkTheme();
        case AppThemeMode.amoled:
          return AppTheme.amoledTheme();
      }
    }

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
    );
  }
}
