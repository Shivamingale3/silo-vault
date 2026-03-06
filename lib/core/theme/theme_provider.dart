import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silo_vault/core/enums/app_enums.dart';
import 'package:silo_vault/core/security/secure_storage.dart';

class ThemeNotifier extends Notifier<AppThemeMode> {
  final AppThemeMode _initialTheme;

  ThemeNotifier([this._initialTheme = AppThemeMode.dark]);

  @override
  AppThemeMode build() {
    return _initialTheme;
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
    SecureStorage.setAppTheme(mode.name);
  }

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      setTheme(AppThemeMode.dark);
    } else if (state == AppThemeMode.dark) {
      setTheme(AppThemeMode.amoled);
    } else {
      setTheme(AppThemeMode.light);
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(() {
  return ThemeNotifier();
});
