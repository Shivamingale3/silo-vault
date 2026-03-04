import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DevModeNotifier extends Notifier<bool> {
  static const _devModeKey = 'dev_mode_enabled';
  final _storage = const FlutterSecureStorage();

  @override
  bool build() {
    _loadState();
    return false; // Return initial false synchronously while loading
  }

  Future<void> _loadState() async {
    final value = await _storage.read(key: _devModeKey);
    if (value == 'true') {
      state = true;
    }
  }

  Future<void> toggleDevMode(bool enabled) async {
    state = enabled;
    await _storage.write(key: _devModeKey, value: enabled.toString());
  }
}

final devModeProvider = NotifierProvider<DevModeNotifier, bool>(() {
  return DevModeNotifier();
});
