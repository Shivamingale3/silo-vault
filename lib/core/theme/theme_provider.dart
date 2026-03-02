import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/enums/app_enums.dart';

class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    return AppThemeMode.dark; // Defaulting to dark
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      state = AppThemeMode.dark;
    } else if (state == AppThemeMode.dark) {
      state = AppThemeMode.amoled;
    } else {
      state = AppThemeMode.light;
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(() {
  return ThemeNotifier();
});
